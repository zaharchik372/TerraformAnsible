# README.md


# DevOps Portfolio (Flask + Docker + Nginx)


Продакшн‑готовый мини‑сайт на Flask для демонстрации навыков DevOps.


## Быстрый старт


```bash
docker compose up -d --build
```


## Что внутри
- Flask‑приложение с endpoint `/healthz`.
- Gunicorn как WSGI‑сервер, нерутовый пользователь.
- Nginx обратный прокси, кэширование статики, security‑заголовки.
- Healthcheck для зависимостей compose.
- Страницы с примерами и подсказками по Ansible/Terraform.


## Prod заметки
- Проброси 80/443 вместо 8080 в `docker-compose.yml`.
- Включи TLS (mount сертификатов и `listen 443 ssl` в `nginx.conf`).
- Логи Nginx и сервиса — в stdout/stderr контейнеров.
- Для автодеплоя: Ansible `community.docker.docker_compose_v2` или GitLab CI SSH.