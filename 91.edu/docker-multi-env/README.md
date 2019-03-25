# Modify configuration files when docker run
- https://github.com/tryolabs/nginx-docker
- docker run 시점에 Environment값을 기준으로
- jinja template를 통해 환경설정 파일을 생성한다.

## pass env when docker run 
```
> docker run -d -p 80:80  -e "NGINX_ENABLE_SSL=True" our-nginx
```
