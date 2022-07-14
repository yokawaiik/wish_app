// import '../constants/translations_constants.dart' show wishInfo, settings;

class EnLanguage {
  Map<String, String> get language => {
        // ? info: global translations
        'error_title': "Error",
        'error_it_is_not_correct_path': "It isn't correct path...",
        'error_it_is_need_to_get_from_server': "It's need to get from server",
        'error_the_wish_was_delete': "The wish was delete.",
        'error_something_went_wrong': "Something went wrong.",
        'error_when_delete_the_wish': "Error when delete the wish. Try later.",
        'error_in_api': "Error in Api.",
        // ? info: settings module
        'settings_appbar_title': 'Settings',
        'settings_language_item_system': 'System',
        'settings_language_item_english': 'English',
        'settings_language_item_russian': 'Russian',
        'settings_theme_item_system': 'System',
        'settings_theme_item_light': 'Light',
        'settings_theme_item_dark': 'Dark',
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
      };
}
