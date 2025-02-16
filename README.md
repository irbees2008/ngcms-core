ngcms-core
==========

[![Join the chat at https://gitter.im/vponomarev/ngcms-core](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/vponomarev/ngcms-core?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Репозиторий файлов ядра NGCMS.
Не забывайте, что ядро не может работать самостоятельно без набора необходимых плагинов.

# Установка вариант 1
1. Скачать содержимое данного репозитория в корневой каталог WEB сервера.
2. Скачать содержимое репозитория (полностью, либо выбранные плагины) https://github.com/vponomarev/ngcms-plugins в каталог engine/plugins/
3. Установить composer (если он ещё не установлен)
4. Выполнить установку зависимостей composer'а командой composer install
5. Открыть в WEB сервере ваш будущий сайт и следовать по указанным шагам.
   
# Установка вариант 2
1. Зайти во вкладку Actions https://github.com/irbees2008/ngcms-core/actions
2. Выбрать в All workflows любой Build source code нажать .
3. Вследующем окне выбрать ngcms-current-build и скачать .
4. Скачиваем,рапаковываем,заливаем на хостинг , устанавливаем .
------------------------------------------------------------------------------------
<h2>Администрирование сайта:</h2>
<p>Для администрирования сайта необходимо любой из современных браузеров.</p>

<p class="zametka">Перед установкой необходимо скачать последнюю версию NGCMS <a href="https://ngcms.ru/">с официального сайта</a>, либо с <a href="https://github.com/vponomarev/ngcms-core">GIT репозитория</a>.</p>
<ul class="spisok">
<li>Распакуйте архив с дистрибутивом во временный каталог.</li>
<li>Загрузите все файлы из временного каталога в корневой каталог вашего сайта.</li>
<li>Выставьте необходимые права доступа для следующих файлов/каталогов:
<ul class="spisok">
<li>папка: uploads/ (и все папки внутри)</li>
<li>папка: templates/ (и все папки внутри)</li>
<li>папка: engine/conf/ (и все файлы внутри)</li>
<li>папка: engine/backups/</li>
<li>папка: engine/cache/</li>
<li>папка: engine/skin/default/tpl (и все папки внутри)</li>
<li>все файлы (*.tpl) во всех папках: templates/</li>
</ul>
</li>
<li>Наберите в браузере адрес вашего сайта</li>
<li>Следуйте дальнейшим инструкциям</li>
</ul>
<h2>Установка системы</h2>
<p>Фактически установка системы состоит из 7 простых шагов, проядя которые вы полочите полностью рабочую CMS.</p>
<h3>Шаг 1: Лицензионное соглашение</h2>
<p>На данном шаге Вам нужно ознакомиться с лицензионным соглашением NGCMS и принять его, поставиь соответствующую галочку внизу страницы. (рис 2.1)</p>
<p class="img"><img width="839" src="https://ngcmshak.ru/readme/help/images/screenshots/install_1.png" />
<br />рис 2.1 </p>
<h3>Шаг 2: Настройка БД</h2>
<p>На данной странице Вам необходимо ввести параметры подключения к БД. (рис 2.2)</p>
<p class="img"><img width="839" src="https://ngcmshak.ru/readme/help/images/screenshots/install_2.png" />
<br />рис 2.2 </p>
<h3>Шаг 3: Проверка доступов</h2>
<p>На данном шаге выполняется проверка на соответствие характеристик сервера к минимальные требования скрипта. Также проверяется правильно ли выставлены права доступа (chmod) к директориями. (рис 2.3)</p>
<p class="img"><img width="839" src="https://ngcmshak.ru/readme/help/images/screenshots/install_3.png" />
<br />рис 2.3 </p>
<h3>Шаг 4: Активация плагинов</h2>
<p>На данной странице отображается список плагинов, входящих в поставку NGCMS. Некоторые из них вы можете активировать прямо здесь. (рис 2.4)</p>
<p class="img"><img width="839" src="https://ngcmshak.ru/readme/help/images/screenshots/install_4.png" />
<br />рис 2.4 </p>
<h3>Шаг 5: Выбор шаблона</h2>
<p>На данной странице вам предстоит выбрать шаблон для NGCMS. (рис 2.5)</p>
<p class="img"><img width="839" src="https://ngcmshak.ru/readme/help/images/screenshots/install_5.png" />
<br />рис 2.5 </p>
<h3>Шаг 6: Общие параметры</h2>
<p>На данном шаге требуется ввести общие параметры сайта, такие как URL сайта, заголовок, а также логин и пароль для администратора. (рис 2.6)</p>
<p class="img"><img width="839" src="https://ngcmshak.ru/readme/help/images/screenshots/install_6.png" />
