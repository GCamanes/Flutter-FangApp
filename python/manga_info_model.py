import os
import json

from constants import ConstantsHandler
from function_helper import FunctionHelper

Constants = ConstantsHandler()
FunctionHelper = FunctionHelper()


class MangaInfoModel:
    def __init__(self):
        self.authors = []
        self.link = ''
        self.key = ''
        self.title = ''
        self.status = Constants.WRONG_LINK_CHECKING
        self.lastChapter = ''
        self.firstChapter = ''
        self.coverLink = ''
        self.lastRelease = ''

    @classmethod
    def fromHtmlContent(cls, link, htmlContent):
        obj = cls()

        obj.link = link
        obj.key = link[1:]

        nextLineMangaCover = False

        for line in htmlContent:
            if nextLineMangaCover:
                nextLineMangaCover = False
                try:
                    obj.coverLink = line.split('data-src="')[-1].split('"')[0].split(':')[0]
                    obj.coverLink = '{}{}'.format(Constants.HTTPS, obj.coverLink)
                except:
                    pass

            if '<div class="img-cover">' in line:
                nextLineMangaCover = True
            if '<h1>' in line:
                try:
                    if Constants.ERROR_404 in line:
                        obj = cls()
                        break
                    title = line.split('<h1>')[1].split('</h1>')[0]
                    obj.title = title
                except:
                    pass
            if '/authors/' in line:
                try:
                    newAuthor = line.split('title="')[1].split('"')[0]
                    obj.authors.append(newAuthor)
                except:
                    pass
            if '/status/' in line:
                try:
                    status = line.split('/status/')[1].split('"')[0]
                    obj.status = status
                except:
                    pass
            if '<ul class="chapter-list"' in line:
                try:
                    lastChapter = line.split('<a href="')[1].split('"')[0]
                    title = line.split('title="')[1].split('"')[0].lower()
                    if 'chapter' in title:
                        obj.lastRelease = title.split('chapter ')[-1].split(':')[0]
                    obj.lastChapter = lastChapter
                    firstChapter = line.split('<a href="')[-1].split('"')[0]
                    obj.firstChapter = firstChapter
                except:
                    pass

        return obj

    @classmethod
    def fromJson(cls, mangaKey):
        obj = cls()  # cls.__new__(cls) does not call __init__ (if needed)
        # super(MangaInfoModel, obj).__init__() # Call any polymorphic base class initializers

        filePath = '{}/{}/{}.json'.format(Constants.MANGA_DL_PATH, mangaKey, mangaKey)

        try:
            with open(filePath, "r") as fp:
                jsonObject = json.load(fp)
                obj.authors = jsonObject['authors']
                obj.link = jsonObject['link']
                obj.key = jsonObject['key']
                obj.title = jsonObject['title']
                obj.coverLink = jsonObject['coverLink']
                obj.status = jsonObject['status']
                obj.lastChapter = jsonObject['lastChapter']
                obj.firstChapter = jsonObject['firstChapter']
                obj.lastRelease = jsonObject['lastRelease']

        except:
            pass

        return obj

    def checking(self):
        return self.status != Constants.WRONG_LINK_CHECKING

    def toString(self):
        return 'Title: {} ({})\nAuthors: {}\nStatus: {}' \
               '\nLast chapter: {}'.format(self.title, self.link, ', '.join(self.authors),
                                           self.status, self.lastRelease)

    def toDict(self):
        return {
            "title": self.title,
            "link": self.link,
            "coverLink": self.coverLink,
            "key": self.key,
            "authors": self.authors,
            "status": self.status,
            "firstChapter": self.firstChapter,
            "lastChapter": self.lastChapter,
            "lastRelease": self.lastRelease,
        }

    def toDictForFirebase(self, chapterKeys):
        return {
            Constants.MANGA_DOC_TITLE: self.title,
            Constants.MANGA_DOC_KEY: self.key,
            Constants.MANGA_DOC_AUTHORS: self.authors,
            Constants.MANGA_DOC_STATUS: self.status,
            Constants.MANGA_DOC_COVER: self.coverLink,
            Constants.MANGA_DOC_LAST_RELEASE: self.lastRelease,
            Constants.MANGA_DOC_CHAPTER_KEYS: chapterKeys,
        }

    # Function to build manga dl path
    def buildMangaPath(self):
        return '{}{}/'.format(Constants.MANGA_DL_PATH, self.link)

    # Function to create manga dl directory
    def createMangaDirectory(self):
        if not os.path.exists(Constants.MANGA_DL_PATH):
            os.makedirs(Constants.MANGA_DL_PATH)
        mangaPath = self.buildMangaPath()
        if not os.path.exists(mangaPath):
            os.makedirs(mangaPath)
            # Save cover file
            fileNamePath = '{}{}'.format(
                self.buildMangaPath(), self.coverLink.split('/')[-1])

            commandLine = "curl -o '{}' '{}'".format(fileNamePath, self.coverLink)
            # Download img file
            os.system(commandLine)
            # Rename file with real extension
            self.coverLink = FunctionHelper.renameFileExtension(fileNamePath) \
                .split(Constants.MANGA_DL_PATH + '/')[-1]
        else:
            oldMangaInfo = MangaInfoModel.fromJson(self.link)
            self.coverLink = oldMangaInfo.coverLink

    def saveMangaInfoToJson(self):
        with open('{}/{}.json'.format(self.buildMangaPath(), self.key), "w") as outfile:
            json.dump(self.toDict(), outfile, indent=4)
