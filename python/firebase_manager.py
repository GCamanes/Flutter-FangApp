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

# FIREBASE
SERVICE_ACCOUNT_KEY_PATH = './python/ServiceAccountKey.json'

# COLLECTION NAMES (CLOUD FIRESTORE)
LIST_COLLECTION = u'mangasList'
LIST_DOCUMENT = u'mangas'
LIST_DOCUMENT_FIELD = u'list'

# MANGA WEBSITE
WEBSITE = 'http://www.mangapanda.com/'

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
        manga = self.mangaManager.getManga(mangaUrlPart)

#-----------------------------------------------------------------------------------
# MANGA MANAGER
#-----------------------------------------------------------------------------------
class MangaManager:
    def __init__(self):
        self.website = WEBSITE

    def getManga(self, mangaUrlPart):
        print('# GETTING INFO ON', mangaUrlPart, '...')

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
