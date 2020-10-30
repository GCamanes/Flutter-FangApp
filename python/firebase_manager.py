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
WEBSITE = 'http://www.mangapanda.com/'
MANGA_IMG_DIV = 'mangaimg'
MANGA_PROPERTIES_DIV = 'mangaproperties'
MANGA_PROPERTY_TD = 'propertytitle'
MANGA_CHAPTERS_LIST_DIV = 'chapterlist'
MANGA_CHAPTERS_LIST_DIV_END = '<div class="clear"'
MANGA_CHAPTER_PAGE_SELECT = 'pageMenu'

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
        self.removeMangaFromMangasList(mangaInfos['key'], mangasList)
        mangasList.append(mangaInfos)
        try:
            self.store.collection(LIST_COLLECTION).document(LIST_DOCUMENT).set({
                u'list': sorted(mangasList, key=itemgetter('name')),
            })
            print('SUCCESS firestore list item', strAction, mangaInfos['key'])
        except Exception as error:
            print('\n/!\ ERROR firestore list item', strAction, mangaInfos['key'], str(error))
            sys.exit()

    def addManga(self, mangaKey):
        try:
            mangasList = self.getMangasList()
            mangaInfos = self.mangaManager.getMangaInfos(mangaKey)
            existingManga = self.findMangaInMangasList(mangaInfos['key'], mangasList)
            if (existingManga != None):
                mangaInfos['lastChapter'] = existingManga['lastChapter']
            self.updateMangaListItem(mangasList, mangaInfos, 'ADDING')
            if (existingManga == None):
                self.store.collection(MANGAS_COLLECTION).document(mangaInfos['key']).set({u'chaptersList': []})
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
                print('\nSUCCESS {} deleted from firestore'.format(mangaKey))
            else:
                print('\n/!\ ERROR DELETING MANGA {} not in manga list'.format(mangaKey))
        except Exception as error:
            print('\n/!\ ERROR DELETING MANGA {} : {}'.format(mangaKey, str(error)))
            sys.exit()

    def updateManga(self, mangaKey):
        mangasList = self.getMangasList()
        existingManga = self.findMangaInMangasList(mangaKey, mangasList)

        if (existingManga != None):
            print('\nUPDATING {} ...'.format(existingManga['key']))
            dictChapters = self.mangaManager.getMangaChaptersDico(existingManga['key'])
            for chapter in dictChapters:
                currentChapter = dictChapters[chapter]
                if (existingManga['lastChapter'] == 'None' or currentChapter['number'] > existingManga['lastChapter']):
                    self.updateMangaChapterOnFirestore(mangasList, existingManga, currentChapter)
                    existingManga = self.findMangaInMangasList(mangaKey, mangasList)

            print('\nSUCCESS {} updated on firestore'.format(existingManga['key']))
        else:
            print('\n/!\ ERROR manga {} not in manga list'.format(mangaKey))

    def updateMangaChapterOnFirestore(self, mangasList, existingManga, chapter):
        try:
            print('    UPLOADING {} chapter {} at {}{} ...'.format(existingManga['name'], chapter['number'], WEBSITE, chapter['url']))
            self.mangaManager.getChapterPages(chapter)

            mangaDoc = self.store.collection(MANGAS_COLLECTION).document(existingManga['key'])

            if (mangaDoc.get().to_dict() == None):
                chaptersList = []
            else:
                chaptersList = mangaDoc.get().to_dict()[u'chaptersList']

            chaptersList.append(self.mangaManager.getChapterKey(existingManga['key'],chapter['number']))
            mangaDoc.set({
                u'chaptersList': chaptersList,
            })

            self.store.collection(MANGAS_COLLECTION) \
                .document(existingManga['key']) \
                .collection(MANGA_CHAPTERS_COLLECTION) \
                .document(self.mangaManager.getChapterKey(existingManga['key'],chapter['number'])) \
                .set(chapter)

            existingManga['lastChapter'] = chapter['number']
            self.updateMangaListItem(mangasList, existingManga, 'UPDATE CHAPTER')

        except Exception as error:
            print('/!\ ERROR in UPLOADING {} chapter {} : {}'.format(existingManga['key'], chapter['number'], str(error)))
            sys.exit()

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
            'key': mangaKey,
            'name': '',
            'imgUrl': '',
            'url': url,
            'status': '',
            'author': '',
            'released': '',
            'lastChapter': 'None',
        }

        # Get html content in a file
        os.system('curl -s {} +  > {}'.format(url, MANGA_INFOS_PATH))
        # read the file
        f = open(MANGA_INFOS_PATH, 'r')
        content = f.readlines()
        f.close()
        os.system('rm {}'.format(MANGA_INFOS_PATH))

        isImgSaved = False
        inPropertiesDiv = False
        nextIsProperty = False
        properties = []
        for line in content:
            if (isImgSaved):
                if (MANGA_PROPERTIES_DIV in line):
                    inPropertiesDiv = True
                    continue
                if (inPropertiesDiv and MANGA_PROPERTY_TD in line):
                    nextIsProperty = True
                    continue
                if (nextIsProperty and '<td>' in line and '</td>' in line and len(properties) < 4):
                    properties.append(line.split('<td>')[1].split('</td>')[0])
                    nextIsProperty = False
                if ('</div>' in line):
                    inPropertiesDiv = False
                    break

            elif (MANGA_IMG_DIV in line):
                mangaInfos['imgUrl'] = line.split('src="')[1].split('"')[0]
                isImgSaved = True

        mangaInfos['name'] = properties[0]
        mangaInfos['released'] = properties[1]
        mangaInfos['status'] = properties[2]
        mangaInfos['author'] = properties[3]

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

        inChaptersListDiv = False
        for line in content:
            if (inChaptersListDiv and MANGA_CHAPTERS_LIST_DIV_END in line):
                inChaptersListDiv = False
                break
            if (MANGA_CHAPTERS_LIST_DIV in line):
                inChaptersListDiv = True
                continue
            if (inChaptersListDiv and mangaKey in line):
                chapterUrl = line.split('<a href="/')[1].split('"')[0]
                chapterNumber = self.getChapterNumber(chapterUrl.split('/')[-1])
                chapterTitle = line.split('</td>')[0].split(' : ')[1]

                if (chapterNumber not in dictChapters.keys()):
                    dictChapters[chapterNumber] = {
                        'number': chapterNumber,
                        'title': chapterTitle,
                        'url': chapterUrl,
                    }

        return dictChapters

    def getChapterPages(self, chapter):
        url = '{}{}'.format(self.website, chapter['url'])
        # Get html content in a file
        os.system('curl -s {} > {}'.format(url, MANGA_CHAPTER_PATH))
        # read the file
        f = open(MANGA_CHAPTER_PATH, 'r')
        content = f.readlines()
        f.close()
        os.system('rm {}'.format(MANGA_CHAPTER_PATH))

        pagesList = []

        inPageSelect = False
        for line in content:
            if (inPageSelect and '</select>' in line):
                break
            if (MANGA_CHAPTER_PAGE_SELECT in line):
                inPageSelect = True
            if (inPageSelect and chapter['url'] in line):
                pageUrl = line.split('<option value="/')[1].split('"')[0]
                if (len(pageUrl.split('/')) == 3):
                    pageNumber = self.getPageName(pageUrl.split('/')[-1])
                else:
                    pageNumber = self.getPageName('1')
                pagesList.append({
                    'page': pageNumber,
                    'url': pageUrl,
                    'urlImg': '',
                })

        for page in pagesList:
            self.getPage(page)

        chapter['pages'] = pagesList

    def getPage(self, page):
        url = '{}{}'.format(self.website, page['url'])
        # Get html content in a file
        os.system('curl -s {} | grep "<img" > {}'.format(url, MANGA_CHAPTER_PAGE_PATH))
        # read the file
        f = open(MANGA_CHAPTER_PAGE_PATH, 'r')
        content = f.readlines()
        f.close()
        os.system('rm {}'.format(MANGA_CHAPTER_PAGE_PATH))

        for line in content:
            page['urlImg'] = line.split('src="')[1].split('"')[0]

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

if __name__ == "__main__":
    main()
