#!/bin/bash

echo "Для выполнения скрипта нужны права администратора."
sudo -v
if [ $? -ne 0 ]; then
    echo "Ошибка: Не удалось получить sudo-права. Скрипт завершает работу."
    exit 1
fi

if ! command -v brew &> /dev/null; then
    echo "Установка Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [ $? -ne 0 ]; then
        echo "Ошибка: Не удалось установить Homebrew."
        exit 1
    fi
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if ! command -v mvn &> /dev/null; then
    echo "Установка Maven..."
    brew install maven
    if [ $? -ne 0 ]; then
        echo "Ошибка: Не удалось установить Maven."
        exit 1
    fi
fi

if ! command -v npm &> /dev/null; then
    echo "Установка Node.js..."
    brew install node
    if [ $? -ne 0 ]; then
        echo "Ошибка: Не удалось установить Node.js."
        exit 1
    fi
fi

if [ -d "$HOME/Рабочий стол" ]; then
    desktop_base="$HOME/Рабочий стол"
elif [ -d "$HOME/Desktop" ]; then
    desktop_base="$HOME/Desktop"
else
    echo "Ошибка: Не удалось найти папку рабочего стола ('Рабочий стол' или 'Desktop')."
    exit 1
fi

echo -e "\nПеренеси папку с плагином на рабочий стол ($desktop_base)."
while true; do
    echo -n "Введи имя папки: "
    read folder_name
    folder_name=$(echo "$folder_name" | xargs)
    if [ -z "$folder_name" ]; then
        echo "Ошибка: Имя папки не может быть пустым."
        continue
    fi
    desktop_path="$desktop_base/$folder_name"
    if [ -d "$desktop_path" ]; then
        if [ -r "$desktop_path" ] && [ -x "$desktop_path" ]; then
            echo "Папка '$folder_name' найдена."
            break
        else
            echo "Ошибка: Нет прав доступа к папке '$folder_name'."
            exit 1
        fi
    else
        echo "Ошибка: Папка '$folder_name' не найдена на рабочем столе."
        echo "Попробуй ещё раз или проверь правильность имени."
    fi
done

echo -e "\nВыбери способ сборки плагина:
1) Maven (mvn clean package)
2) JavaScript (npm build)
Введи номер (1-2): "
read build_method

cd "$desktop_path" || { echo "Ошибка: Не удалось перейти в папку '$desktop_path'."; exit 1; }

case $build_method in
    1)
        echo "Сборка плагина через Maven..."
        if [ ! -f "pom.xml" ]; then
            echo "Ошибка: Файл 'pom.xml' не найден в папке '$folder_name'."
            exit 1
        fi
        mvn clean package
        if [ $? -eq 0 ]; then
            echo "Сборка Maven прошла успешно."
            jar_file=$(find target -maxdepth 1 -name "*.jar" | head -n 1)
            if [ -z "$jar_file" ]; then
                echo "Ошибка: Файл .jar не найден в папке 'target'."
                exit 1
            fi
            mv "$jar_file" "$desktop_base/"
            plugin_path="$desktop_base/$(basename "$jar_file")"
            echo "Плагин перенесён на рабочий стол."
        else
            echo "Ошибка при сборке Maven."
            exit 1
        fi
        ;;
    2)
        echo "Сборка плагина через JavaScript (npm build)..."
        if [ ! -f "package.json" ]; then
            echo "Ошибка: Файл 'package.json' не найден в папке '$folder_name'."
            exit 1
        fi
        npm install && npm run build
        if [ $? -eq 0 ]; then
            echo "Сборка npm прошла успешно."
            if [ -d "dist" ]; then
                mv dist "$desktop_base/dist_$(basename "$desktop_path")"
                plugin_path="$desktop_base/dist_$(basename "$desktop_path")"
                echo "Папка dist перенесена на рабочий стол."
            else
                echo "Ошибка: Папка 'dist' не найдена после сборки."
                exit 1
            fi
        else
            echo "Ошибка при сборке npm."
            exit 1
        fi
        ;;
    *)
        echo "Ошибка: Неверный выбор. Введи число 1 или 2."
        exit 1
        ;;
esac

echo -e "\nТвой плагин находится на рабочем столе"
echo "Путь к плагину: $plugin_path"

echo -e "\n================
By: Хейви
YT: https://www.youtube.com/@Xeuvy
GitHub: https://github.com/Xeuvy
================\n"
