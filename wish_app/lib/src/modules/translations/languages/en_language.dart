// import '../constants/translations_constants.dart' show wishInfo, settings;

import '../constants/translations_constants.dart' as translations_constants;

class EnLanguage {
  String get language => translations_constants.localeEnUS.toString();

  Map<String, String> get translations => {
        // ? info: global translations
        'error_title': "Error",
        'error_it_is_not_correct_path': "It isn't correct path...",
        'error_it_is_need_to_get_from_server': "It's need to get from server",
        'error_the_wish_was_delete': "The wish was delete.",
        'error_something_went_wrong': "Something went wrong.",
        'error_when_delete_the_wish': "Error when delete the wish. Try later.",
        'error_in_api': "Error in Api.",
        'error_unknown': "Unknown error.",
        // ? info: other
        "warning_title": 'Warning',
        // ?
        // ? info: settings module
        'settings_appbar_title': 'Settings',
        'settings_language_item_system': 'System',
        'settings_language_item_english': 'English',
        'settings_language_item_russian': 'Russian',
        'settings_theme_item_system': 'System',
        'settings_theme_item_light': 'Light',
        'settings_theme_item_dark': 'Dark',
        // ?
        // ? info: wish module
        // ? info: utils
        'wish_utils_check_link_field_name': 'Link',
        'wish_utils_check_link_link_message': 'Link is wrong.',
        // ? info: wish info screen with controller
        'wish_info_appbar_title': 'Wish info',
        'wish_info_icon_title_button_edit': 'Edit',
        'wish_info_icon_title_button_delete': 'Delete',
        // ? info: wish add screen with controller
        'wish_add_appbar_title_is_edit_true': 'Edit wish',
        'wish_add_appbar_title_is_edit_false': 'New wish',
        'wish_add_default_text_field_title_label': 'Title',
        'wish_add_default_text_field_description_label': 'Description',
        'wish_add_default_text_field_link_label': 'Link',
        'wish_add_elevated_button_text_is_edit_true': 'Save',
        'wish_add_elevated_button_text_is_edit_false': 'Create',
        // ? info: wish add controller : errors
        'wa_e_not_a_creator': 'You are not a creator.',
        'wa_e_wish_does_not_exist_or_was_delete':
            'You want to edit wish but wish with this id doesn\'t exist or was delete.',
        'wa_es_wish_not_found': 'The wish not found.',
        'wa_e_getting_wish': 'Error getting wish.',
        'wa_e_creating_wish': 'Error creating wish.',
        'wa_e_updating_wish': 'Error updating wish.',
        // ?
        // ? info: account module
        // ? info: account view
        'account_view_list_tile_text_create_new_wish': 'Create new wish',
        'account_view_list_tile_text_my_account': 'My Account',
        'account_view_list_tile_text_is_user_authenticated_true': 'Sign Out',
        'account_view_list_tile_text_is_user_authenticated_false': 'Log In',
        'account_view_button_counter_title_wishes': 'Wishes',
        'account_view_button_counter_title_followers': 'Followers',
        'account_view_button_counter_title_following': 'Following',
        'account_view_elevated_button_text_edit_profile': 'Edit profile',
        'account_view_elevated_button_text_has_subscribe_true': 'Unfollow',
        'account_view_elevated_button_text_has_subscribe_false': 'Follow',
        'account_view_popup_menu_item_title_delete_wish': 'Delete wish',
        // ? info: errors in account controller
        'account_ac_es_it_is_not_an_user': 'It isn\'t an user.',
        'account_ac_e_unknown_error': 'Unknown error...',
        'account_ac_e_error_subscribing': 'Error subscribing.',
        // ? info: account api services
        // ? info: errors in account api services
        'account_aas_es_such_an_user_did_not_find': "Such an user didn't find.",
        'account_aas_es_error_when_get_subscription_info':
            "Error when get subscription info.",
        // ? info: account edit view
        'account_edit_view_appbar_title': 'Edit account info',
        'account_edit_view_text_button': 'Change profile photo',
        'account_edit_view_default_text_field_label': 'Login',
        'account_edit_view_elevated_button_text_set_new_info': 'Set new info',
        'account_edit_view_password_text_field_label_new_password':
            'New password',
        'account_edit_view_password_text_field_label_retype_new_password':
            'Retype new password',
        'account_edit_view_elevated_button_text_set_new_password':
            'Set new password',
        // ? info: errors in account edit controller
        'account_aec_e_this_login_is_already_taken':
            'This login is already taken.',
        // ? info: account edit api services
        // ? info: errors in account edit api services
        'account_aeas_es_error_updating_password': "Error updating password.",
        'account_aeas_es_error_updating_login': "Error updating login.",
        'account_aeas_es_error_updating_user_info': "Error updating user info.",
        'account_aeas_es_error_updating_user_avatar':
            "Error when update user info.",
        // ? info: utils
        'account_utils_account_edit_validators_check_password_fields_is_not_equal':
            'These fields is not equal.',
        // TODO:  auth module
        // ?
        // ? info: auth module
      };
}
