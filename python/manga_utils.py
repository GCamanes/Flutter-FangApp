import os
import subprocess

from constants import ConstantsHandler
from function_helper import FunctionHelper

from manga_search_model import MangaSearchModel
from manga_info_model import MangaInfoModel
from chapter_info_model import ChapterInfoModel

Constants = ConstantsHandler()
FunctionHelper = FunctionHelper()


class MangaManager:
    def __init__(self):
        self.website = Constants.WEBSITE

    # Function to search manga on search term
    @staticmethod
    def searchManga(searchTerm):
        # build search url
        url = FunctionHelper.buildSearchUrl(searchTerm)
        # build command line
        output = subprocess.check_output(
            "curl -s '{}' | grep '<div class=\"book-item' | grep 'img'"
            .format(url), shell=True, text=True)

        # format raw content
        lines = ''.join(output).replace('\n                     ', ' ').split('<div class="book'
                                                                              '-item">')[1:]

        return FunctionHelper.mapEasy(lines, MangaSearchModel)

    # Function to get all info on a manga
    @staticmethod
    def getMangaInfo(link):
        # build search url
        url = FunctionHelper.buildMangaInfoUrl(link)
        # build command line
        output = subprocess.check_output(
            "curl -s '{}'".format(url), shell=True, text=True)
        content = output.split('\n')

        return MangaInfoModel.fromHtmlContent(link, content)

    # Function to get all info on a chapter
    @staticmethod
    def getChapterInfo(link):
        # build search url
        url = FunctionHelper.buildMangaInfoUrl(link)
        # build command line

        output = subprocess.check_output(
            "curl -s '{}'".format(url), shell=True, text=True)
        content = output.split('\n')

        return ChapterInfoModel(link, content)
