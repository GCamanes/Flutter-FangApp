# SETUP
# python3 -m pip install firebase-admin
# python3 -m pip install google-cloud-firestore

# download private key from firebase project
# then name it ServiceAccountKey.json
# then place it in /python directory

#-----------------------------------------------------------------------------------
# MAIN FUNCTION
#-----------------------------------------------------------------------------------
def main():

    # Cloud Firestore certificate
    cred = credentials.Certificate("./ServiceAccountKey.json")
    app = firebase_admin.initialize_app(cred)
    # Get firestore client to interact with distant database
    store = firestore.client()
