import 'package:ezdehar/core/app_strings/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ezdehar/core/extensions/context_extensions.dart';
import 'package:ezdehar/core/utils/extentions.dart';
import 'package:ezdehar/shared/widgets/edit_text_widget.dart';
import 'package:ezdehar/shared/widgets/grad_button_widget.dart';
import 'package:ezdehar/shared/widgets/two_tile_app_bar.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../cubit/chat_bot_cubit.dart';
import '../../cubit/chat_bot_states.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBotCubit(),
      child: BlocConsumer<ChatBotCubit, ChatBotStates>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          final cubit = ChatBotCubit.get(context);
          return Scaffold(
            appBar: TwoTitleAppBar(
              title: LocaleKeys.chatbot.tr(),
              subtitle: LocaleKeys.talk_to_smart_chatbot.tr(),
            ),
            bottomNavigationBar: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 20 + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: TextFormFieldWidget(
                type: TextInputType.text,
                hintText: LocaleKeys.how_can_i_help_you.tr(),
                password: false,
                suffixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GradButtonWidget(
                    width: 45,
                    height: 45,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [SvgPicture.asset("send".svg()), const Gap(5)],
                    ),
                    onTap: () {},
                  ),
                ),
              ),
            ),
            body:
                true
                    ? SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset("bot_chat".svg()),
                          const Gap(10),
                          Text(
                            LocaleKeys.welcome.tr(),
                            style: context.titleMedium?.copyWith(
                              color: context.primaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const Gap(10),
                          SizedBox(
                            width: 164,
                            child: Text(
                              LocaleKeys.just_type_what_you_need_help_with.tr(),
                              textAlign: TextAlign.center,
                              style: context.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    )
                    : PagedListView.separated(
                      pagingController: cubit.pagingController,
                      builderDelegate: PagedChildBuilderDelegate(
                        itemBuilder: (context, item, index) {
                          return Container();
                        },
                      ),
                      separatorBuilder: (context, index) {
                        return const Gap(10);
                      },
                    ),
          );
        },
      ),
    );
  }
}
