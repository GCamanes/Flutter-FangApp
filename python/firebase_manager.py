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
            print('SUCCESS firestore list item', strAction, mangaInfos['name'])
        except Exception as error:
            print('\n/!\ ERROR firestore list item', strAction, mangaInfos['key'], str(error))
            sys.exit()

    def addManga(self, mangaUrlPart):
        try:
            mangasList = self.getMangasList()
            mangaInfos = self.mangaManager.getMangaInfos(mangaUrlPart)
            exististingManga = self.findMangaInMangasList(mangaInfos['key'], mangasList)
            if (exististingManga != None):
                mangaInfos['lastChapter'] = exististingManga['lastChapter']
            self.updateMangaListItem(mangasList, mangaInfos, 'ADDING')
            if (exististingManga == None):
                self.store.collection(MANGAS_COLLECTION).document(mangaInfos['key']).set({u'chaptersList': []})
        except Exception as error:
            print('\n/!\ ERROR ADDING MANGA {} : {}'.format(mangaUrlPart, str(error)))

    def deleteManga(self, mangaKey):
        try:
            mangasList = self.getMangasList()
            exististingManga = self.findMangaInMangasList(mangaKey, mangasList)
            if (exististingManga != None):
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
                print('\n/!\ ERROR manga {} not in manga list'.format(mangaKey))
        except Exception as error:
            print('\n/!\ ERROR DELETING MANGA {} : {}'.format(mangaKey, str(error)))
            sys.exit()

#-----------------------------------------------------------------------------------
# MANGA MANAGER
#-----------------------------------------------------------------------------------
class MangaManager:
    def __init__(self):
        self.website = WEBSITE

    def getMangaInfos(self, mangaUrlPart):
        url = '{}{}'.format(WEBSITE, mangaUrlPart)
        print('# GETTING INFO ON {} at {} ...'.format(mangaUrlPart, url))

        # Initialize manga getMangaInfos
        mangaInfos = {
            'key': mangaUrlPart,
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

#-----------------------------------------------------------------------------------
# MAIN FUNCTION
#-----------------------------------------------------------------------------------
def main():

    # Init FirebaseManager
    firebaseManager = FirebaseManager()

    #firebaseManager.addManga('one-piece')
    firebaseManager.deleteManga('one-piece')

if __name__ == "__main__":
    main()
