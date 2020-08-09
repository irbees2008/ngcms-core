<?php

global $permRules;
$permRules = [
    '#admin'    => [
        'title'       => 'Административные настройки CMS',
        'description' => '',
        'items'       => [
            'system' => [
                'title'     => 'Общие настройки системы',
                'items'     => [
                    'admpanel.view'                     => ['title'     => 'Доступ в админ-панель'],
                    'lockedsite.view'                   => ['title'     => 'Просмотр заблокированного сайта'],
                    'debug.view'                        => ['title'     => 'Просмотр отладочной информации'],
                    '*'                                 => ['title'     => '** Значение по умолчанию **'],

                ],
            ],
            'configuration' => [
                'title'     => 'Управление глобальными настройками CMS',
                'items'     => [
                    'details'                       => ['title'     => 'Просмотр настроек'],
                    'modify'                        => ['title'     => 'Редактирование настроек'],
                    '*'                             => ['title'     => '** Значение по умолчанию **'],

                ],
            ],
            'static' => [
                'title'     => 'Управление статическими страницами',
                'items'     => [
                    'view'                      => ['title'     => 'Просмотр списка'],
                    'details'                   => ['title'     => 'Просмотр конкретных статических страниц'],
                    'modify'                    => ['title'     => 'Редактирование статических страниц'],
                    //					'*'							=> array(	'title'	=> '** DEFAULT **',											),
                ],
            ],
            'users' => [
                'title'     => 'Управление пользователями',
                'items'     => [
                    //					'*'							=> array(	'title'	=> '** DEFAULT **',											),
                    'view'                      => ['title'     => 'Просмотр списка'],
                    'details'                   => ['title'     => 'Просмотр профиля пользователя'],
                    'modify'                    => ['title'     => 'Редактирование профиля пользователя'],
                ],
            ],
            'cron' => [
                'title'     => 'Управление планировщиком задач',
                'items'     => [
                    'details'                   => ['title'     => 'Просмотр настроек планировщика задач'],
                    'modify'                    => ['title'     => 'Изменение настроек планировщика задач'],
                ],
            ],
            'rewrite' => [
                'title'     => 'Управление форматом ссылок',
                'items'     => [
                    'details'                   => ['title'     => 'Просмотр настроек управления ссылками'],
                    'modify'                    => ['title'     => 'Изменение настроек управления ссылок'],
                ],
            ],
            'ipban' => [
                'title'     => 'Блокировка пользователей по IP адресу',
                'items'     => [
                    'view'                      => ['title'     => 'Просмотр списка заблокированных IP адресов'],
                    'modify'                    => ['title'     => 'Редактирование списка'],
                    //					'*'							=> array(	'title'	=> '** DEFAULT **',											),
                ],
            ],
            'categories' => [
                'title'     => 'Управление категориями',
                'items'     => [
                    'view'                          => ['title'     => 'Просмотр списка категорий'],
                    'details'                       => ['title'     => 'Просмотр настроек конкретных категорий'],
                    'modify'                        => ['title'     => 'Редактирование категорий'],
                    'list.admin'                    => ['title' => 'Категории, в которых разрешено управление новостями', 'type' => 'listCategoriesSelector#withDefault'],
                    //					'*'							=> array(	'title'	=> '** DEFAULT **',											),
                ],
            ],
            'news' => [
                'title'       => 'Управление новостями',
                'description' => 'Интерфейс управления новостями (добавление, удаление,..)',
                'items'       => [
                    'view'                          => ['title'     => 'Просмотр списка новостей'],
                    'add'                           => ['title'     => 'Добавление новостей'],
                    'add.mainpage'                  => ['title'     => 'Значение по умолчанию для флага "размещение новости на главной"'],
                    'add.pinned'                    => ['title'     => 'Значение по умолчанию для флага "прикрепление новости на главной"'],
                    'add.catpinned'                 => ['title'     => 'Значение по умолчанию для флага "прикрепление новости в категории"'],
                    'add.favorite'                  => ['title'     => 'Значение по умолчанию для флага "добавление новости в закладки"'],
                    'add.html'                      => ['title'     => 'Значение по умолчанию для флага "использование HTML кода в новостях"'],
                    'add.raw'                       => ['title'     => 'Значение по умолчанию для флага "отключить автоформатирование"'],
                    'unapproved'                    => ['title'     => 'Показ счечика неопубликованных новостей'],
                    'personal.list'                 => ['title'     => 'Собственные новости: Просмотр списка'],
                    'personal.view'                 => ['title'     => 'Собственные новости: Просмотр содержимого'],
                    'personal.modify'               => ['title'     => 'Собственные новости: Редактирование'],
                    'personal.modify.published'     => ['title'     => 'Собственные новости: Редактирование опубликованных'],
                    'personal.publish'              => ['title'     => 'Собственные новости: Публикация'],
                    'personal.unpublish'            => ['title'     => 'Собственные новости: Снятие с публикации'],
                    'personal.delete'               => ['title'     => 'Собственные новости: Удаление'],
                    'personal.delete.published'     => ['title'     => 'Собственные новости: Удаление опубликованных'],
                    'personal.html'                 => ['title'     => 'Собственные новости: Использование HTML кода'],
                    'personal.mainpage'             => ['title'     => 'Собственные новости: Размещение на главной'],
                    'personal.pinned'               => ['title'     => 'Собственные новости: Прикрепление на главной'],
                    'personal.catpinned'            => ['title'     => 'Собственные новости: Прикрепление в категории'],
                    'personal.favorite'             => ['title'     => 'Собственные новости: Добавление в закладки'],
                    'personal.setviews'             => ['title'     => 'Собственные новости: Установка кол-ва просмотров'],
                    'personal.multicat'             => ['title'     => 'Собственные новости: Размещение в нескольких категориях'],
                    'personal.nocat'                => ['title'     => 'Собственные новости: Размещение вне категории'],
                    'personal.customdate'           => ['title'     => 'Собственные новости: Изменение даты публикации'],
                    'personal.altname'              => ['title'     => 'Собственные новости: Задание альт. имени'],
                    'other.list'                    => ['title'     => 'Чужие новости: Просмотр списка'],
                    'other.view'                    => ['title'     => 'Чужие новости: Просмотр содержимого'],
                    'other.modify'                  => ['title'     => 'Чужие новости: Редактирование'],
                    'other.modify.published'        => ['title'     => 'Чужие новости: Редактирование опубликованных'],
                    'other.publish'                 => ['title'     => 'Чужие новости: Публикация'],
                    'other.unpublish'               => ['title'     => 'Чужие новости: Снятие с публикации'],
                    'other.delete'                  => ['title'     => 'Чужие новости: Удаление'],
                    'other.delete.published'        => ['title'     => 'Чужие новости: Удаление опубликованных'],
                    'other.html'                    => ['title'     => 'Чужие новости: Использование HTML кода'],
                    'other.mainpage'                => ['title'     => 'Чужие новости: Размещение на главной'],
                    'other.pinned'                  => ['title'     => 'Чужие новости: Прикрепление на главной'],
                    'other.catpinned'               => ['title'     => 'Чужие новости: Прикрепление в категории'],
                    'other.favorite'                => ['title'     => 'Чужие новости: Добавление в закладки'],
                    'other.setviews'                => ['title'     => 'Чужие новости: Установка кол-ва просмотров'],
                    'other.multicat'                => ['title'     => 'Чужие новости: Размещение в нескольких категориях'],
                    'other.nocat'                   => ['title'     => 'Чужие новости: Размещение вне категории'],
                    'other.customdate'              => ['title'     => 'Чужие новости: Изменение даты публикации'],
                    'other.altname'                 => ['title'     => 'Чужие новости: Задание альт. имени'],
                    '*'                             => ['title'     => '** Значение по умолчанию **'],
                ],
            ],
            'dbo' => [
                'title'     => 'Управление базой данных',
                'items'     => [
                    'details'                   => ['title'     => 'Просмотр текущего состояния базы данных'],
                    'modify'                    => ['title'     => 'Изменение в базе данных'],
                ],
            ],
            'templates' => [
                'title'     => 'Управление шаблонами',
                'items'     => [
                    'details'                   => ['title'     => 'Просмотр шаблонов'],
                    'modify'                    => ['title'     => 'Изменение шаблонов'],
                ],
            ],

            'perm' => [
                'title'     => 'Права доступа',
                'items'     => [
                    'details'                       => ['title'     => 'Просмотр раздела'],],
                    'modify'                        => ['title'     => 'Редактирование'],],
                    '*'                             => ['title'     => '** Значение по умолчанию **'],
                ],
            ],
            'ugroup' => [
                'title'     => 'Группа пользователей',
                'items'     => [
                    'details'                       => ['title'     => 'Просмотр раздела'],],
                    'modify'                        => ['title'     => 'Редактирование'],],
                    '*'                             => ['title'     => '** Значение по умолчанию **'],
                ],
            ],
            'dbo' => [
                'title'     => 'База данных',
                'items'     => [
                    'details'                       => ['title'     => 'Просмотр раздела'],],
                    'modify'                        => ['title'     => 'Редактирование'],],
                    '*'                             => ['title'     => '** Значение по умолчанию **'],
                ],
            ],
            'extras' => [
                'title'     => 'Плагины',
                'items'     => [
                    'details'                       => ['title'     => 'Просмотр раздела'],],
                    'modify'                        => ['title'     => 'Редактирование'],],
                    '*'                             => ['title'     => '** Значение по умолчанию **'],
                ],
            ],
            'extra-config' => [
                'title'     => 'Настройки плагина',
                'items'     => [
                    'details'                       => ['title'     => 'Просмотр раздела'],],
                    'modify'                        => ['title'     => 'Редактирование'],],
                    '*'                             => ['title'     => '** Значение по умолчанию **'],
                ],
            ],
            'statistics' => [
                'title' => 'Статистика',
                'items'     => [
                    'details'                       => ['title'     => 'Просмотр раздела'],],
                    'modify'                        => ['title'     => 'Редактирование'],],
                    '*'                             => ['title'     => '** Значение по умолчанию **'],
                ],
            ],
            'editcomments' => [
                'title'     => 'Редактирование коментариев',
                'items'     => [
                    'details'                       => ['title'     => 'Просмотр раздела'],],
                    'modify'                        => ['title'     => 'Редактирование'],],
                    '*'                             => ['title'     => '** Значение по умолчанию **'],
                ],
            ],
            'options' => [
                'title'     => 'Настройки системы',
                'items'     => [
                    'details'                       => ['title'     => 'Просмотр раздела'],],
                    'modify'                        => ['title'     => 'Редактирование'],],
                    '*'                             => ['title'     => '** Значение по умолчанию **'],
                ],
            ],
            'files' => [
                'title'     => 'Файлы',
                'items'     => [
                    'details'                       => ['title'     => 'Просмотр раздела'],],
                    'modify'                        => ['title'     => 'Редактирование'],],
                    '*'                             => ['title'     => '** Значение по умолчанию **'],
                ],
            ],
            'images' => [
                'title'     => 'Изображения',
                'items'     => [
                    'details'                       => ['title'     => 'Просмотр раздела'],],
                    'modify'                        => ['title'     => 'Редактирование'],],
                    '*'                             => ['title'     => '** Значение по умолчанию **'],
                ],
            ],
            'pm' => [
                'title'     => 'Личные сообщения',
                'items'     => [
                    'details'                       => ['title'     => 'Просмотр раздела'],],
                    'modify'                        => ['title'     => 'Редактирование'],],
                    '*'                             => ['title'     => '** Значение по умолчанию **'],
                ],
            ],
            'preview' => [
                'title'     => 'Просмотр',
                'items'     => [
                    'details'                       => ['title'     => 'Просмотр раздела'],],
                    'modify'                        => ['title'     => 'Редактирование'],],
                    '*'                             => ['title'     => '** Значение по умолчанию **'],
                ],
            ],
        ],
    ],
    'nsm'   => [
        'title'         => 'Плагин NSM',
        'items'         => [
            ''          => [
                'items'             => [
                    'add'                   => ['title'     => 'Добавление новостей'],
                    'list'                  => ['title'     => 'Просмотр списка новостей'],
                    'view'                  => ['title'     => 'Просмотр содержимого новости'],
                    'view.draft'            => ['title'     => 'Просмотр содержимого черновика'],
                    'view.unpublished'      => ['title'     => 'Просмотр содержимого модерируемой новости'],
                    'view.published'        => ['title'     => 'Просмотр содержимого опубликованной новости'],
                    'modify.draft'          => ['title'     => 'Изменение содержимого черновика'],
                    'modify.unpublished'    => ['title'     => 'Изменение содержимого модерируемой новости'],
                    'modify.published'      => ['title'     => 'Изменение содержимого опубликованной новости'],
                    'delete.draft'          => ['title'     => 'Удаление содержимого черновика'],
                    'delete.unpublished'    => ['title'     => 'Удаление содержимого модерируемой новости'],
                    'delete.published'      => ['title'     => 'Удаление содержимого опубликованной новости'],

                ],
            ],
        ],
    ],

];
