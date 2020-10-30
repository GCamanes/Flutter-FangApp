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
            print('/!\ ERROR in getting manga list')
            sys.exit()
        return mangasList

    def addManga(self, mangaUrlPart):
        try:
            mangaInfos = self.mangaManager.getMangaInfos(mangaUrlPart)
            print('MANGA INFOS', mangaInfos)
        except Exception as e:
            print('# ERROR ADDING MANGA', mangaUrlPart, ':', str(e))

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

    mangasList = firebaseManager.getMangasList()
    print('MANGA LIST', mangasList)

    firebaseManager.addManga('one-piece')

if __name__ == "__main__":
    main()
