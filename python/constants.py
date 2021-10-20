# -----------------------------------------------------------------------------------
# CONSTANTS
# -----------------------------------------------------------------------------------

def constant(f):
    def fset(self, value):
        raise TypeError

    def fget(self):
        return f(self)

    return property(fget, fset)


class ConstantsHandler(object):
    # FILES
    @constant
    def PATH(self):
        return './python'

    # DOWNLOAD
    @constant
    def MANGA_DL_PATH(self):
        return './manga-dl'

    # FIREBASE
    @constant
    def SERVICE_ACCOUNT_KEY_PATH(self):
        return '{}/ServiceAccountKey.json'.format(self.PATH)

    # MANGA WEBSITE
    @constant
    def HTTPS(self):
        return 'https:'

    @constant
    def WEBSITE(self):
        return 'https://mangabuddy.com/'

    @constant
    def SEARCH_PART(self):
        return 'search?q='

    # MANGA VALUES
    @constant
    def ERROR_404(self):
        return '404'

    @constant
    def WRONG_LINK_CHECKING(self):
        return 'WRONG_LINK'

    @constant
    def DISABLED(self):
        return 'disabled'

    # COLLECTION NAMES (CLOUD FIRESTORE)
    @constant
    def MANGAS_COLLECTION(self):
        return u'mangas'

    @constant
    def CHAPTERS_COLLECTION(self):
        return u'chapters'

    @constant
    def MANGA_DOC_TITLE(self):
        return u'title'

    @constant
    def MANGA_DOC_AUTHORS(self):
        return u'authors'

    @constant
    def MANGA_DOC_KEY(self):
        return u'key'

    @constant
    def MANGA_DOC_STATUS(self):
        return u'status'

    @constant
    def MANGA_DOC_COVER(self):
        return u'coverLink'

    @constant
    def MANGA_DOC_LAST_RELEASE(self):
        return u'lastRelease'

    @constant
    def MANGA_DOC_CHAPTER_KEYS(self):
        return u'chapterKeys'

    @constant
    def CHAPTER_DOC_NUMBER(self):
        return u'number'

    @constant
    def CHAPTER_DOC_PAGES(self):
        return u'pages'
