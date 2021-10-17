import 'package:fangapp/core/data/app_constants.dart';
import 'package:fangapp/core/extensions/string_extension.dart';
import 'package:fangapp/core/localization/app_localizations.dart';
import 'package:fangapp/core/widget/app_bar_widget.dart';
import 'package:fangapp/core/widget/reload_icon_widget.dart';
import 'package:fangapp/core/widget/tab_bar_widget.dart';
import 'package:fangapp/feature/mangas/presentation/cubit/mangas_cubit.dart';
import 'package:fangapp/feature/mangas/presentation/widgets/mangas_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../get_it_injection.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  bool _hasLoadAtLeastOnce = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    getIt<AppLocalizations>().localChanged.listen(_onLocaleChanged);
    BlocProvider.of<MangasCubit>(context).getMangas();
    _tabController = TabController(
      vsync: this,
      length: 2,
    );
  }

  Future<void> _onLocaleChanged(String language) async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return BlocConsumer<MangasCubit, MangasState>(
      listener: (BuildContext context, MangasState state) async {
        if (state is MangasLoaded || state is MangasError) {
          setState(() {
            _hasLoadAtLeastOnce = true;
          });
        }
      },
      builder: (BuildContext context, MangasState state) {
        return Scaffold(
          appBar: AppBarWidget(
            titleWidget: Image.asset(
              'assets/images/fangapp_logo.png',
              width: size.width * 0.4,
            ),
            isInitialPage: true,
            actionsList: <Widget>[
              AnimatedOpacity(
                opacity: _hasLoadAtLeastOnce ? 1.0 : 0.0,
                duration: AppConstants.animDefaultDuration,
                child: ReloadIconWidget(
                  onPress: state is! MangasLoading
                      ? () => BlocProvider.of<MangasCubit>(context).getMangas()
                      : null,
                ),
              )
            ],
            bottom: TabBarWidget(
              labels: <String>[
                'common.all'.translate(),
                'common.favorites'.translate()
              ],
              tabController: _tabController,
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: <Widget>[
              MangasListWidget(emptyMessage: 'mangas.noMangas'.translate()),
              MangasListWidget(
                showOnlyFavorites: true,
                emptyMessage: 'mangas.noFavorites'.translate(),
              ),
            ],
          ),
        );
      },
    );
  }
}
