// import "../constants/translations_constants.dart" show wishInfo, settings;

import "../constants/translations_constants.dart" as translations_constants;

class RuLanguage {
  String get language => translations_constants.localeRuRU.toString();

  Map<String, String> get translations => {
        // ? info: global translations
        "error_title": "Ошибка",
        "error_it_is_not_correct_path": "Это неправильный путь...",
        "error_it_is_need_to_get_from_server": "Необходимо получить с сервера",
        "error_the_wish_was_delete": "Желание было удалено.",
        "error_something_went_wrong": "Что-то пошло не так.",
        "error_when_delete_the_wish":
            "Ошибка при удалении желания. Повторите попытку позже.",
        "error_in_api": "Ошибка API.",
        "error_unknown": "Неизвестная ошибка.",
        "error_db_unknown_title": "Ошибка базы данных",
        "error_db_unknown_message": "Неизвестная ошибка в базе данных.",
        "error_m_something_went_wrong": "Что-то пошло не так.",
        // ? info: other
        "warning_title": "Предупреждение",
        // ?
        // ? info: settings module
        "settings_appbar_title": "Настройки",
        "settings_language_item_system": "Система",
        "settings_language_item_english": "Английский",
        "settings_language_item_russian": "Русский",
        "settings_theme_item_system": "Система",
        "settings_theme_item_light": "Светлый",
        "settings_theme_item_dark": "Темный",
        // ?
        // ? info: wish module
        // ? info: utils
        "wish_utils_check_link_field_name": "Ссылка",
        "wish_utils_check_link_link_message": "Ссылка неверна.",
        // ? info: wish info screen with controller
        "wish_info_appbar_title": "Информация о желании",
        "wish_info_icon_title_button_edit": "Изменить",
        "wish_info_icon_title_button_delete": "Удалить",
        // ? info: wish add screen with controller
        "wish_add_appbar_title_is_edit_true": "Редактировать желание",
        "wish_add_appbar_title_is_edit_false": "Новое желание",
        "wish_add_default_text_field_title_label": "Заголовок",
        "wish_add_default_text_field_description_label": "Описание",
        "wish_add_default_text_field_link_label": "Ссылка",
        "wish_add_elevated_button_text_is_edit_true": "Сохранить",
        "wish_add_elevated_button_text_is_edit_false": "Создать",
        // ? info: wish add controller > errors
        "wa_e_not_a_creator": "Вы не создатель.",
        "wa_e_wish_does_not_exist_or_was_delete":
            "Вы хотите отредактировать желание, но желание с таким идентификатором не существует или было удалено.",
        "wa_es_wish_not_found": "Желание не найдено.",
        "wa_e_getting_wish": "Ошибка получения желания.",
        "wa_e_creating_wish": "Ошибка создания желания.",
        "wa_e_updating_wish": "Ошибка обновления желания.",
        // ?
        // ? info: account module
        // ? info: account view
        "account_view_list_tile_text_create_new_wish": "Создать новое желание",
        "account_view_list_tile_text_my_account": "Мой аккаунт",
        "account_view_list_tile_text_is_user_authenticated_true": "Выйти",
        "account_view_list_tile_text_is_user_authenticated_false": "Войти",
        "account_view_button_counter_title_wishes": "Желания",
        "account_view_button_counter_title_followers": "Подписчики",
        "account_view_button_counter_title_following": "Подписки",
        "account_view_elevated_button_text_edit_profile":
            "Редактировать профиль",
        "account_view_elevated_button_text_has_subscribe_true": "Отписаться",
        "account_view_elevated_button_text_has_subscribe_false": "Подписаться",
        "account_view_popup_menu_item_title_delete_wish": "Удалить желание",
        "am_av_pmi_add_to_favorites": "Добавить в любимые",
        "am_av_pmi_remove_from_favorites": "Удалить из любимых",
        "am_av_lt_settings": "Настройки",
        // ? info: errors in account controller
        "account_ac_es_it_is_not_an_user": "Это не пользователь.",
        "account_ac_e_unknown_error": "Неизвестная ошибка...",
        "account_ac_e_error_subscribeing": "Ошибка подписки.",
        // // ? info: account api services
        // ? info: errors in account api services
        "account_aas_es_such_an_user_did_not_find":
            "Такой пользователь не найден.",
        "account_aas_es_error_when_get_subscription_info":
            "Ошибка при получении информации о подписке.",
        // ? info: account edit view
        "account_edit_view_appbar_title":
            "Редактировать информацию об учетной записи",
        "account_edit_view_text_button": "Изменить фото профиля",
        "account_edit_view_default_text_field_label": "Войти",
        "account_edit_view_elevated_button_text_set_new_info":
            "Установить новую информацию",
        "account_edit_view_password_text_field_label_new_password":
            "Новый пароль",
        "account_edit_view_password_text_field_label_retype_new_password":
            "Введите повторно новый пароль",
        "account_edit_view_elevated_button_text_set_new_password":
            "Установить новый пароль",
        // ? info: errors in account edit controller
        "account_aec_e_this_login_is_already_taken": "Такой логин уже занят.",
        // // ? info: account edit api services
        // ? info: errors in account edit api services
        "account_aeas_es_error_updating_password": "Ошибка обновления пароля.",
        "account_aeas_es_error_updating_login": "Ошибка обновления логина.",
        "account_aeas_es_error_updating_user_info":
            "Ошибка обновления информации о пользователе.",
        "account_aeas_es_error_updating_user_avatar":
            "Ошибка при обновлении информации о пользователе.",
        // ? info: utils
        "account_utils_account_edit_validators_check_password_fields_is_not_equal":
            "Эти поля не равны.",
        // ?
        // ? info: auth module
        // ? info: auth view
        "auth_av_form_title": "Войти",
        "auth_av_dtf_label_login": "Войти",
        "auth_av_dtf_label_email": "Электронная почта",
        "auth_av_ptf_label_password": "Пароль",
        "auth_av_tb_text_is_sign_in_true": "У вас уже есть аккаунт?",
        "auth_av_tb_text_is_sign_in_false": "У вас нет учетной записи?",
        "auth_av_rb_text_is_sign_in_true": "Зарегистрируйтесь сейчас",
        "auth_av_rb_text_is_sign_in_false": "Войти",
        // // ? info: auth controller
        // ? info: auth controller > errors
        "auth_ac_es_error_login": "Ошибка входа.",
        // // ? info: auth api service
        // ? info: auth api service > errors
        "auth_aas_es_m_error_sign_in": "Ошибка входа",
        "auth_aas_es_m_error_sign_up": "Ошибка регистрации.",
        "auth_aas_es_such_login_already_exist": "Такой логин уже существует.",
        "auth_aas_es_such_email_already_exist": "Такое письмо уже существует.",
        // ?
        // ? info: connection manager module
        // ? info: connection manager widgets
        "cm_w_text_check_your_connection":
            "Пожалуйста, проверьте подключение к интернету...",
        // ?
        // ? info: favorites module
        // ? info: favorites view
        "fm_fv_text_on_empty_screen":
            "Здесь вы можете сохранить обоснованные пожелания...",
        "fm_fv_lt_text_remove_from_favorites": "Удалить из избранного",
        "fm_fv_lt_text_see_profile": "Посмотреть профиль",
        // // ? info: favorites controller
        // // ? info: favorites controller > error
        // // ? info: favorites api service
        // ? info: favorites api service > error
        "fm_fas_es_get_count_of_favorites": "Ошибка подсчета избранного.",
        "fm_fas_es_find_an_added_favorite":
            "Ошибка при поиске добавленного избранного желания.",
        "fm_fas_es_delete_favorite": "Ошибка удаления избранного желания.",
        // ?
        // ? info: splash module
        // ? info: splash view
        "s_sv_text_on_screen": "Здравствуй, подожди немного...",
        // ?
        // ? info: home module
        // ? info: home main view
        "fm_hmv_appbar_title": "Главная",
        "fm_hmv_bs_lv_add_to_favorites": "Добавить в избранное",
        "fm_hmv_bs_lv_delete_from_favorites": "Удалить из избранного",

        "fm_hmv_bs_lv_delete": "Удалить",
        "fm_hmv_bs_lv_see_profile": "Просмотреть профиль",
        // // ? info: home controller
        // // ? info: home controller > error
        // // ? info: home main controller
        // ? info: home main controller > error
        "hm_hmc_e_load_wish_list": "Ошибка загрузки последнего списка желаний",
        // // ? info: home api service
        // // ? info: home api service > error
        // ? info: wishes and users search delegate
        "hm_wausd_br_query_empty_center_text": "Твой поиск пуст...",
        "hm_wausd_error_center_text": "Что-то пошло не так...",
        "hm_wausd_br_list_empty_center_text": "Такой информации не найдено...",
        "hm_wausd_result_category_users": "Пользователи",
        "hm_wausd_result_category_wishes": "Желания",
        "hm_wausd_bs_suggestions_lists_empty": "У тебя нет предложений...",
        // ?
        // ? info: navigator module
        // ? info: navigator view
        "nm_nv_pmb_pmi_sign_out": "Выйти",
        "nm_nv_pmb_pmi_sign_in": "Войти",
        "nm_nv_nb_nd_favorites": "Избранное",
        "nm_nv_nb_nd_home": "Главная",
        "nm_nv_nb_nd_account": "Учетная запись",
        // // ? info: navigator controller
        // ? info: navigator utils
        "nm_u_show_exit_popup_title": "Выход из приложения",
        "nm_u_show_exit_popup_content": "Вы хотите выйти?",
        "nm_u_show_exit_popup_confirm": "Да",
        "nm_u_show_exit_popup_cancel": "Нет",
        // ?
        // ? info: global module
        // ? info: global utils
        "gm_u_check_email_field_name": "Электронная почта",
        "gm_u_check_email_email_message":
            "Неправильный адрес электронной почты.",
        "gm_u_check_password_field_name": "Пароль",
        "gm_u_check_login_field_name": "Войти",
        "gm_u_base_field_check_default_min_length_message":
            "@fieldName должно быть больше, чем @minLength.",
        "gm_u_base_field_check_default_max_length_message":
            "@fieldName должно быть меньше, чем @maxLength.",
        "gm_u_base_field_check_default_empty_length_message":
            "Требуется @fieldName.",
        "gm_u_only_numbers_and_letters_check_message":
            "@fieldName должен содержать только буквы и цифры.",
        // ? info: global api services
        // ? info: add wish api service > errors
        "gm_awas_es_error_adding_wish": "Ошибка при добавлении нового желания.",
        "gm_awas_es_error_updating":
            "Такое желание было удалено или другая ошибка.",
        "gm_awas_es_error_removing_image": "Ошибка удаления изображения.",
        "gm_awas_es_error_uploading_image": "Ошибка загрузки изображения.",
        // ? info: user api service > errors
        "gm_uas_es_error_getting_user": "Ошибка получения пользователя.",
        "gm_uas_es_error_getting_user_info":
            "Ошибка получения информации о пользователе.",
      };
}
