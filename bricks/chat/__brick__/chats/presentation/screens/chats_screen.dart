import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../core/Router/Router.dart';
import '../../../../core/app_strings/locale_keys.dart';
import '../../../../core/extensions/all_extensions.dart';
import '../../../../core/utils/extentions.dart';
import '../../../../shared/widgets/colored_container.dart';
import '../../../../shared/widgets/empty_widget.dart';
import '../../../../shared/widgets/network_image.dart';
import '../../../../shared/widgets/two_tile_app_bar.dart';
import '../../cubit/chats_cubit.dart';
import '../../cubit/chats_states.dart';
import '../../domain/model/chats_model.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatsCubit()..addpageListener(),
      child: BlocConsumer<ChatsCubit, ChatsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = ChatsCubit.get(context);
          return Scaffold(
            appBar: TwoTitleAppBar(
              title: LocaleKeys.conversations.tr(),
              subtitle: LocaleKeys.registered_companies_list.tr(),
              canPop: false,
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                cubit.chatPagingcontroller.refresh();
              },
              child: PagedListView.separated(
                pagingController: cubit.chatPagingcontroller,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                builderDelegate: PagedChildBuilderDelegate<ChatModel>(
                  itemBuilder: (context, item, index) {
                    return ChatItem(item: item);
                  },
                  noItemsFoundIndicatorBuilder: (context) {
                    return EmptyWidget(
                      image: "nochats",
                      title: LocaleKeys.no_previous_conversations.tr(),
                      subtitle: LocaleKeys.no_conversation_yet.tr(),
                    );
                  },
                ),
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 10);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class ChatItem extends StatelessWidget {
  const ChatItem({super.key, this.item});
  final ChatModel? item;

  @override
  Widget build(BuildContext context) {
    return ColoredContainer(
      verticalPadding: 10,
      horizontalPadding: 16,
      color: const Color(0xffF6F6F6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ChatCompanyItem(item: item),
          const Gap(4),
          Text(
            item?.last_message?.content ?? "",
            style: context.bodySmall?.copyWith(color: Colors.black),
          ),
          const Gap(15),
        ],
      ),
    ).onTap(() {
      Navigator.pushNamed(
        context,
        Routes.chatScreen,
        arguments: ChatArgs(
          chatId: item?.chatId,
          name:
              "${item?.other_party?.company?.companyName ?? ""} ${item?.other_party?.name != null ? "(${item?.other_party?.name})" : ""}",
          image: item?.other_party?.company?.companyImage ?? "",
        ),
      );
    });
  }
}

class ChatCompanyItem extends StatelessWidget {
  const ChatCompanyItem({super.key, this.item});
  final ChatModel? item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NetworkImagesWidgets(
            item?.other_party?.company?.companyImage ?? "",
            height: 56,
            width: 56,
            radius: 28,
            fit: BoxFit.cover,
          ),
          const Gap(9),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(5),
              Text(
                "${item?.other_party?.company?.companyName ?? ""} ${item?.other_party?.name != null ? "(${item?.other_party?.name})" : ""}",
                style: context.bodySmall,
              ),
              const Gap(5),
              Text(
                item?.last_message?.sentAt ?? "",
                style: context.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Spacer(),
          if (item?.unseen_count != "0")
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  item?.unseen_count ?? "",
                  style: context.labelSmall?.copyWith(color: Colors.white),
                ),
              ),
            ),
          const Gap(8),
        ],
      ),
    );
  }
}
