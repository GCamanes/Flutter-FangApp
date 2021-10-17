#-----------------------------------------------------------------------------------
# SETUP
#-----------------------------------------------------------------------------------
# python3 -m pip install firebase-admin
# python3 -m pip install google-cloud-firestore

# download private key from firebase project
# then name it ServiceAccountKey.json
# then place it in /python directory

# IMPORT
import os
import sys
import html
import argparse
import firebase_admin
import google.cloud
from firebase_admin import credentials, firestore
from operator import itemgetter

#-----------------------------------------------------------------------------------
# CONSTANTS
#-----------------------------------------------------------------------------------

# FILES
PATH = './python'
MANGA_INFOS_PATH = '{}/mangaInfos.txt'.format(PATH)
MANGA_CHAPTERS_PATH = '{}/mangaChapterslist.txt'.format(PATH)
MANGA_CHAPTER_PATH = '{}/mangaChapter.txt'.format(PATH)
MANGA_CHAPTER_PAGE_PATH = '{}/mangaChapterPage.txt'.format(PATH)

# FIREBASE
SERVICE_ACCOUNT_KEY_PATH = '{}/ServiceAccountKey.json'.format(PATH)

# COLLECTION NAMES (CLOUD FIRESTORE)
LIST_COLLECTION = u'mangasList'
LIST_DOCUMENT = u'mangas'
LIST_DOCUMENT_FIELD = u'list'

MANGAS_COLLECTION = u'mangasChapters'
MANGA_LIST_FIELD = u'chaptersList'
MANGA_CHAPTERS_COLLECTION = u'chapters'

# MANGA WEBSITE
WEBSITE = 'https://www.mangareader.net/'
HTTPS = 'https:'

#-----------------------------------------------------------------------------------
# FIREBASE MANAGER
#-----------------------------------------------------------------------------------
class FirebaseManager:
    def __init__(self):
        # Cloud Firestore certificate
        self.cred = credentials.Certificate(SERVICE_ACCOUNT_KEY_PATH)
        self.app = firebase_admin.initialize_app(self.cred)
        # Get firestore client to interact with distant database
        self.store = firestore.client()
        self.mangaManager = MangaManager()

    def getMangasList(self):
        mangasList = []
        try:
            mangasList = self.store.collection(LIST_COLLECTION) \
                .document(LIST_DOCUMENT) \
                .get().to_dict()[LIST_DOCUMENT_FIELD]
        except:
            print('\n/!\ ERROR in getting manga list')
            sys.exit()
        return mangasList

    def showCollectionMangas(self):
        try:
            mangasList = self.getMangasList()
            print('\n** List of manga on firebase **')
            if (len(mangasList) == 0):
                print('   No mangas added to firebase')
            else:
                for (manga, index) in zip(mangasList, range(1, len(mangasList)+1)):
                    print('   {} : {}\n       => {} {}'.format(index, manga[u'name'], manga[u'key'], manga[u'lastChapter']))
        except Exception as error:
            print('\n/!\ ERROR in show manga list :', str(error))
            sys.exit()

    def findMangaInMangasList(self, mangaKey, mangasList):
        mangaToFind = None
        for manga in mangasList:
            if (mangaKey == manga[u'key']):
                mangaToFind = manga
                break
        return mangaToFind

    def removeMangaFromMangasList(self, mangaKey, mangasList):
        mangaToFind = None
        for manga in mangasList:
            if (mangaKey == manga[u'key']):
                mangaToFind = manga
                break
        if (mangaToFind != None):
            mangasList.remove(mangaToFind)

    def updateMangaListItem(self, mangasList, mangaInfos, strAction):
        self.removeMangaFromMangasList(mangaInfos[u'key'], mangasList)
        mangasList.append(mangaInfos)
        try:
            self.store.collection(LIST_COLLECTION).document(LIST_DOCUMENT).set({
                u'list': sorted(mangasList, key=itemgetter('name')),
            })
            print('SUCCESS firestore list item {} {}\n'.format(strAction, mangaInfos[u'key']))
        except Exception as error:
            print('\n/!\ ERROR firestore list item', strAction, mangaInfos[u'key'], str(error))
            sys.exit()

    def addManga(self, mangaKey):
        try:
            mangasList = self.getMangasList()
            mangaInfos = self.mangaManager.getMangaInfos(mangaKey)
            existingManga = self.findMangaInMangasList(mangaInfos[u'key'], mangasList)
            if (existingManga == None):
                self.updateMangaListItem(mangasList, mangaInfos, 'ADDING')
                self.store.collection(MANGAS_COLLECTION).document(mangaInfos[u'key']).set({u'chaptersList': []})
            else:
                print('\n/!\ ERROR ADDING MANGA {} already in manga list'.format(mangaKey))
        except Exception as error:
            print('\n/!\ ERROR ADDING MANGA {} : {}'.format(mangaKey, str(error)))

    def deleteManga(self, mangaKey):
        try:
            mangasList = self.getMangasList()
            existingManga = self.findMangaInMangasList(mangaKey, mangasList)
            if (existingManga != None):
                collection = self.store.collection(MANGAS_COLLECTION).document(mangaKey) \
                    .collection(MANGA_CHAPTERS_COLLECTION).get()

                for doc in collection :
                    self.store.collection(MANGAS_COLLECTION).document(mangaKey)\
                        .collection(MANGA_CHAPTERS_COLLECTION).document(doc.id).delete()
                self.store.collection(MANGAS_COLLECTION).document(mangaKey).delete()

                self.removeMangaFromMangasList(mangaKey, mangasList)
                self.store.collection(LIST_COLLECTION).document(LIST_DOCUMENT).set({
                    u'list': mangasList,
                })
                print('SUCCESS {} deleted from firestore\n'.format(mangaKey))
            else:
                print('\n/!\ ERROR DELETING MANGA {} not in manga list'.format(mangaKey))
        except Exception as error:
            print('\n/!\ ERROR DELETING MANGA {} : {}'.format(mangaKey, str(error)))
            sys.exit()

    def updateManga(self, mangaKey):
        mangasList = self.getMangasList()
        existingManga = self.findMangaInMangasList(mangaKey, mangasList)

        if (existingManga != None):
            print('\nUPDATING {} ...'.format(existingManga[u'key']))
            mangaInfos = self.mangaManager.getMangaInfos(mangaKey)
            if (existingManga[u'status'] != mangaInfos[u'status']):
                existingManga[u'status'] == mangaInfos[u'status']
            dictChapters = self.mangaManager.getMangaChaptersDico(existingManga[u'key'])
            for chapter in dictChapters:
                currentChapter = dictChapters[chapter]
                if (existingManga[u'lastChapter'] == 'None' or currentChapter[u'number'] > existingManga[u'lastChapter']):
                    self.updateMangaChapter(mangasList, existingManga, currentChapter)
                    existingManga = self.findMangaInMangasList(mangaKey, mangasList)

            print('\nSUCCESS {} updated on firestore'.format(existingManga[u'key']))
        else:
            print('\n/!\ ERROR manga {} not in manga list'.format(mangaKey))

    def updateMangaChapter(self, mangasList, existingManga, chapter):
        try:
            print('UPLOADING {} chapter {} at {}{} ...'.format(existingManga[u'name'], chapter[u'number'], WEBSITE, chapter[u'url']))
            self.mangaManager.getChapterPages(chapter)

            mangaDoc = self.store.collection(MANGAS_COLLECTION).document(existingManga[u'key'])

            if (mangaDoc.get().to_dict() == None):
                chaptersList = []
            else:
                chaptersList = mangaDoc.get().to_dict()[u'chaptersList']

            chaptersList.append(self.mangaManager.getChapterKey(existingManga[u'key'],chapter[u'number']))
            mangaDoc.set({
                u'chaptersList': chaptersList,
            })

            self.store.collection(MANGAS_COLLECTION) \
                .document(existingManga[u'key']) \
                .collection(MANGA_CHAPTERS_COLLECTION) \
                .document(self.mangaManager.getChapterKey(existingManga[u'key'],chapter[u'number'])) \
                .set(chapter)

            existingManga[u'lastChapter'] = chapter[u'number']
            self.updateMangaListItem(mangasList, existingManga, 'UPDATE CHAPTER')

        except Exception as error:
            print('/!\ ERROR in UPLOADING {} chapter {} : {}'.format(existingManga[u'key'], chapter[u'number'], str(error)))
            sys.exit()

    def updateAllManga(self):
        print("\nUPDATING ALL ...")
        mangasList = self.getMangasList()
        if (len(mangasList) > 0):
            for manga in mangasList:
                self.updateManga(manga[u'key'])
        else:
            print("\n/!\ no manga to update on firestore")

    def deleteAllManga(self):
        print("\nDELETE ALL ...")
        mangasList = self.getMangasList()
        if (len(mangasList) > 0):
            for manga in mangasList:
                self.deleteManga(manga[u'key'])
        else:
            print("\n/!\ no manga to update on firestore")

#-----------------------------------------------------------------------------------
# MANGA MANAGER
#-----------------------------------------------------------------------------------
class MangaManager:
    def __init__(self):
        self.website = WEBSITE

    # Function to get key of a chapter
    def getChapterKey(self, key, number):
        return '{}_{}'.format(key, number)

    # Function to get the number of a chapter with 4 digits
    def getChapterNumber(self, chap):
    	chapName = ""
    	if (len(chap.split(".")[0]) == 1):
    		chapName = "000"+chap
    	elif (len(chap.split(".")[0]) == 2):
    		chapName = "00"+chap
    	elif (len(chap.split(".")[0]) == 3):
    		chapName = "0"+chap
    	else:
    		chapName = chap
    	return chapName

    # Function to get the string page number (3 digits)
    def getPageName(self, page):
    	strPage = str(page)
    	if (len(strPage) == 1):
    		strPage = "00"+strPage
    	elif (len(strPage) == 2):
    		strPage = "0"+strPage
    	return strPage

    def getMangaInfos(self, mangaKey):
        url = '{}{}'.format(self.website, mangaKey)
        print('# GETTING INFO ON {} at {} ...'.format(mangaKey, url))

        # Initialize manga getMangaInfos
        mangaInfos = {
            u'key': mangaKey,
            u'name': '',
            u'imgUrl': '',
            u'url': url,
            u'status': '',
            u'author': '',
            u'lastChapter': 'None',
        }

        # Get html content in a file
        os.system('curl -s {} +  > {}'.format(url, MANGA_INFOS_PATH))
        # read the file
        f = open(MANGA_INFOS_PATH, 'r')
        content = f.readlines()
        f.close()
        os.system('rm {}'.format(MANGA_INFOS_PATH))

        for lineContent in content:
            lines = '</div>\n'.join(lineContent.split('</div>')).split('\n')
            for line in lines:
                if ('<div class="d38"><img src="' in line):
                    mangaInfos[u'imgUrl'] = HTTPS + line.split('src="')[1].split('"')[0]
                if ('<table class="d41"><tr><td>Name :</td>' in line):
                    contentInfos = line.split('</tr>')
                    mangaInfos[u'name'] = contentInfos[0].split('<span class="name">')[1].split('</span>')[0]
                    mangaInfos[u'status'] = contentInfos[3].split('<td>')[-1].split('</td>')[0]
                    mangaInfos[u'author'] = contentInfos[4].split('<td>')[-1].split('</td>')[0]

        return mangaInfos

    def getMangaChaptersDico(self, mangaKey):
        url = '{}{}'.format(self.website, mangaKey)
        # Get html content in a file
        os.system('curl -s {} > {}'.format(url, MANGA_CHAPTERS_PATH))
        # read the file
        f = open(MANGA_CHAPTERS_PATH, 'r')
        content = f.readlines()
        f.close()
        os.system('rm {}'.format(MANGA_CHAPTERS_PATH))

        dictChapters = {}

        for lineContent in content:
            lines = '</div>\n'.join(lineContent.split('</div>')).split('\n')
            for line in lines:
                if ('<td>Chapter Name</td><td>Date Added</td>' in line):
                    tmpChapters = line.split('<td>Chapter Name</td><td>Date Added</td></tr>')[1] \
                                      .split('</table>')[0] \
                                      .split('<tr>')[1:]

                    for tmpChapter in tmpChapters:
                        chapterUrl = tmpChapter.split('<a href="/')[1].split('"')[0]
                        chapterNumber = self.getChapterNumber(chapterUrl.split('/')[-1])
                        chapterTitle = html.unescape(tmpChapter.split('</td>')[0].split(' : ')[1])

                        if (chapterNumber not in dictChapters.keys()):
                            dictChapters[chapterNumber] = {
                                u'number': chapterNumber,
                                u'title': chapterTitle,
                                u'url': chapterUrl,
                            }

        return dictChapters

    def getChapterPages(self, chapter):
        pagesList = []
        needToStop = False
        pageNumber = 1

        while(not needToStop):
            urlPrefix = ''
            if (pageNumber != 1):
                urlPrefix = '/{}'.format(pageNumber)
            url = '{}{}{}'.format(self.website, chapter[u'url'], urlPrefix)
            # Get html content in a file
            os.system('curl -s {} > {}'.format(url, MANGA_CHAPTER_PATH))
            # read the file
            f = open(MANGA_CHAPTER_PATH, 'r')
            content = f.readlines()
            f.close()
            os.system('rm {}'.format(MANGA_CHAPTER_PATH))

            page = {
                u'page': '',
                u'url': url,
                u'urlImg': '',
            }

            for lineContent in content:
                lines = '</div>\n'.join(lineContent.split('</div>')).split('\n')
                for line in lines:
                    if ('<img id="ci"' in line):
                        page[u'urlImg'] = HTTPS + line.split('src="')[1].split('"')[0]
                    if ('<div id="mci"' in line):
                        page[u'page'] = self.getPageName(line.split('data-id="')[1].split('"')[0])

            pageNumber += 1
            if (page[u'page'] == ''):
                needToStop = True
            else:
                pagesList.append(page)

        chapter[u'pages'] = pagesList

#-----------------------------------------------------------------------------------
# MAIN FUNCTION
#-----------------------------------------------------------------------------------
def main():

    # Init FirebaseManager
    firebaseManager = FirebaseManager()

    mangaKey = 'one-piece'

    #firebaseManager.addManga(mangaKey)
    #firebaseManager.deleteManga(mangaKey)
    #firebaseManager.updateManga(mangaKey)

    # Definition of argument option
    parser = argparse.ArgumentParser(prog="mangaReaderFirebase.py")
    parser.add_argument('-l', '--list',
        help='show list of mangas in firestore',
        action="store_true")
    parser.add_argument('-a', '--add', nargs=1,
        help='add a manga to firestore',
        action='store', type=str)
    parser.add_argument('-d', '--delete', nargs=1,
        help='delete a manga from firestore (use "MangaName")',
        action='store', type=str)
    parser.add_argument('-u', '--update', nargs=1,
        help='update one manga in cloud firestore  (use "MangaName")',
        action='store', type=str)
    parser.add_argument('--uall',
        help='update all mangas in cloud firestore',
        action='store_true')
    parser.add_argument('--dall',
        help='delete all mangas in cloud firestore',
        action='store_true')

    # Parsing of command line argument
    args = parser.parse_args(sys.argv[1:])

    if(args.list == True):
        firebaseManager.showCollectionMangas()
        print()
        sys.exit()

    elif(args.add != None):
        firebaseManager.addManga(args.add[0])
        sys.exit()

    elif(args.delete != None):
        firebaseManager.deleteManga(args.delete[0])
        sys.exit()

    elif(args.update != None):
        firebaseManager.updateManga(args.update[0])
        sys.exit()

    elif(args.uall == True):
        firebaseManager.updateAllManga()
        sys.exit()

    elif(args.dall == True):
        firebaseManager.deleteAllManga()
        sys.exit()

if __name__ == "__main__":
    main()