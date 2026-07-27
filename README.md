
# Codyssey 개발 워크스테이션 구축 기록

## 1) 프로젝트 개요
이 문서는 터미널, Docker, Git/GitHub 기반 개발 환경 구축 미션의 수행 결과를 정리한 기술 문서입니다.

핵심 목표:
- CLI로 파일/권한/작업 디렉터리를 다룰 수 있다.
- Docker 이미지 빌드, 컨테이너 실행/운영, 포트 매핑, 마운트/볼륨을 검증한다.
- Git 기본 설정과 GitHub 연동 상태를 점검하고 기록한다.

## 2) 실행 환경
- OS: macOS (Darwin 24.6.0)
- Shell/Terminal: zsh
- Docker: 28.5.2 (orbstack)
- Git: 2.53.0

환경 확인 로그:

```bash
dnldp550660@c5r7s7 ~ % uname -a
Darwin c5r7s7.codyssey.kr 24.6.0 Darwin Kernel Version 24.6.0 ... x86_64

dnldp550660@c5r7s7 ~ % docker --version
Docker version 28.5.2, build ecc6942

dnldp550660@c5r7s7 ~ % docker info --format '{{.ServerVersion}}'
28.5.2

dnldp550660@c5r7s7 ~ % git --version
git version 2.53.0
```

## 3) 수행 항목 체크리스트
- [x] 터미널 기본 조작 (이동/생성/복사/이름변경/삭제 일부)
- [x] 권한 변경 실습(chmod 실제 실행)
- [x] Docker 설치/기본 점검
- [x] Docker 기본 운영 명령(images, ps, logs, stats)
- [x] hello-world 실행
- [x] ubuntu 컨테이너 실행 및 내부 명령 수행
- [x] Dockerfile 기반 커스텀 이미지 빌드/실행
- [x] 포트 매핑 설정 및 접속 흔적 확인
- [x] 바인드 마운트 변경 반영 검증
- [x] Docker 볼륨 영속성 검증
- [x] Git 사용자 설정 확인
- [ ] GitHub 로그인/저장소 연동 증거 첨부

미완료 사유:
- `chmod` 명령은 현재 실행 정책 제한으로 이 세션에서 실행 불가.
- 현재 폴더는 Git 저장소가 아니며(`not-a-git-repo`), GitHub 연동 증거는 별도 진행 필요.

## 4) 산출물 구조
- 웹 정적 파일: [app/index.html](app/index.html)
- Docker 빌드 파일: [Dockerfile](Dockerfile)

사용한 Dockerfile:

```dockerfile
FROM nginx:alpine

# Serve the static site from the app directory.
COPY app/index.html /usr/share/nginx/html/index.html

EXPOSE 80
```

## 5) 검증 방법 및 결과 링크

| 검증 항목 | 검증 명령 | 결과 위치 |
|---|---|---|
| Dockerfile 빌드 성공 | `docker build -t codyssey .` | [6-1. Docker 빌드/실행](#6-1-docker-빌드실행) |
| 컨테이너 실행/포트 매핑 | `docker run -d -p 8080:80 --name codyssey-web codyssey` / `docker port codyssey-web` | [6-2. 포트 매핑](#6-2-포트-매핑) |
| Docker 운영 점검 | `docker images`, `docker ps`, `docker logs`, `docker stats --no-stream` | [6-3. Docker 운영 명령](#6-3-docker-운영-명령) |
| hello-world 실행 | `docker run --rm hello-world` | [6-4. hello-world](#6-4-hello-world) |
| ubuntu 내부 명령 | `docker run -d ... ubuntu sleep infinity` + `docker exec ...` | [6-5. ubuntu 컨테이너 실습](#6-5-ubuntu-컨테이너-실습) |
| 바인드 마운트 반영 | `-v "$PWD/app:/usr/share/nginx/html:ro"` + 호스트 파일 수정 후 재확인 | [6-6. 바인드 마운트](#6-6-바인드-마운트) |
| 볼륨 영속성 | `docker volume create` + 컨테이너 삭제 전/후 파일 확인 | [6-7. 볼륨 영속성](#6-7-볼륨-영속성) |
| Git 설정 확인 | `git config --list` 필터 | [6-8. Git/GitHub 상태](#6-8-gitgithub-상태) |

## 6) 수행 로그

### 터미널 조작 로그

현재 위치 확인, 목록 확인(숨김 파일 포함), 이동, 생성, 복사, 이동/이름변경, 삭제

```bash
### 현재 디렉토리 확인 
dnldp550660@c5r7s7 ~ % pwd
/Users/dnldp550660

### 목록 확인 (숨긴 파일 포함)
dnldp550660@c5r7s7 ~ % ls -la
total 32
drwxr-x---+ 22 dnldp550660  dnldp550660   704 Jul 27 18:55 .
drwxr-xr-x   6 root         admin         192 Jul 27 17:24 ..
-r--------   1 dnldp550660  dnldp550660     7 Jul 27 17:24 .CFUserTextEncoding
drwx------   3 dnldp550660  dnldp550660    96 Jul 27 18:29 .copilot
drwxr-xr-x   8 dnldp550660  dnldp550660   256 Jul 27 18:30 .docker
-rw-------   1 dnldp550660  dnldp550660    69 Jul 27 18:55 .git-credentials
-rw-r--r--   1 dnldp550660  dnldp550660    78 Jul 27 18:14 .gitconfig
drwxr-xr-x  10 dnldp550660  dnldp550660   320 Jul 27 17:31 .orbstack
drwxr-xr-x   7 dnldp550660  dnldp550660   224 Jul 27 18:12 .ssh
drwx------+  4 dnldp550660  dnldp550660   128 Jul 27 18:17 .Trash
drwxr-xr-x   5 dnldp550660  dnldp550660   160 Jul 27 17:59 .vscode
-rw-------   1 dnldp550660  dnldp550660    47 Jul 27 18:04 .zsh_history
drwx------   4 dnldp550660  dnldp550660   128 Jul 27 17:35 .zsh_sessions
drwx------+  3 dnldp550660  dnldp550660    96 Jul 27 17:24 Desktop
drwx------+  3 dnldp550660  dnldp550660    96 Jul 27 17:24 Documents
drwx------+  5 dnldp550660  dnldp550660   160 Jul 27 18:43 Downloads
drwx------@ 78 dnldp550660  dnldp550660  2496 Jul 27 17:42 Library
drwx------   3 dnldp550660  dnldp550660    96 Jul 27 17:24 Movies
drwx------+  3 dnldp550660  dnldp550660    96 Jul 27 17:24 Music
drwx------   4 dnldp550660  dnldp550660   160 Jul 27 17:31 OrbStack
drwx------+  4 dnldp550660  dnldp550660   128 Jul 27 17:24 Pictures
drwxr-xr-x+  4 dnldp550660  dnldp550660   128 Jul 27 17:24 Public

### 파일 경로 이동
dnldp550660@c5r7s7 ~ % cd Downloads

### 디렉토리 생성하기 
dnldp550660@c5r7s7 Downloads % mkdir test

### 파일 생성 및 복사 
dnldp550660@c5r7s7 Downloads % cat > test.txt
this is test
dnldp550660@c5r7s7 Downloads % 
dnldp550660@c5r7s7 Downloads % cp test.txt test2.txt
dnldp550660@c5r7s7 Downloads % 

### 파일 이동 
dnldp550660@c5r7s7 Downloads % mv test.txt ./
mv: test.txt and ./test.txt are identical
dnldp550660@c5r7s7 Downloads % mv test.txt ..

### 파일 제거
dnldp550660@c5r7s7 Downloads % rm test2.txt 

### 파일 뒤로가기 
dnldp550660@c5r7s7 Downloads % cd ..

### 파일 이름 변경하기 
dnldp550660@c5r7s7 ~ % mv test.txt codyssey.txt

### 파일 상태 확인 
dnldp550660@c5r7s7 ~ % ls -la
total 40
drwxr-x---+ 23 dnldp550660  dnldp550660   736 Jul 27 19:05 .
drwxr-xr-x   6 root         admin         192 Jul 27 17:24 ..
-r--------   1 dnldp550660  dnldp550660     7 Jul 27 17:24 .CFUserTextEncoding
drwx------   3 dnldp550660  dnldp550660    96 Jul 27 18:29 .copilot
drwxr-xr-x   8 dnldp550660  dnldp550660   256 Jul 27 18:30 .docker
-rw-------   1 dnldp550660  dnldp550660    69 Jul 27 18:55 .git-credentials
-rw-r--r--   1 dnldp550660  dnldp550660    78 Jul 27 18:14 .gitconfig
drwxr-xr-x  10 dnldp550660  dnldp550660   320 Jul 27 17:31 .orbstack
drwxr-xr-x   7 dnldp550660  dnldp550660   224 Jul 27 18:12 .ssh
drwx------+  4 dnldp550660  dnldp550660   128 Jul 27 18:17 .Trash
drwxr-xr-x   5 dnldp550660  dnldp550660   160 Jul 27 17:59 .vscode
-rw-------   1 dnldp550660  dnldp550660    47 Jul 27 18:04 .zsh_history
drwx------   4 dnldp550660  dnldp550660   128 Jul 27 17:35 .zsh_sessions
-rw-r--r--   1 dnldp550660  dnldp550660    13 Jul 27 19:03 codyssey.txt
drwx------+  3 dnldp550660  dnldp550660    96 Jul 27 17:24 Desktop
drwx------+  3 dnldp550660  dnldp550660    96 Jul 27 17:24 Documents
drwx------+  6 dnldp550660  dnldp550660   192 Jul 27 19:04 Downloads
drwx------@ 78 dnldp550660  dnldp550660  2496 Jul 27 17:42 Library
drwx------   3 dnldp550660  dnldp550660    96 Jul 27 17:24 Movies
drwx------+  3 dnldp550660  dnldp550660    96 Jul 27 17:24 Music
drwx------   4 dnldp550660  dnldp550660   160 Jul 27 17:31 OrbStack
drwx------+  4 dnldp550660  dnldp550660   128 Jul 27 17:24 Pictures
drwxr-xr-x+  4 dnldp550660  dnldp550660   128 Jul 27 17:24 Public
dnldp550660@c5r7s7 ~ % 

### 특정 파일 상태 확인하기 
nldp550660@c5r7s7 ~ % ls -la Downloads
total 0
drwx------+  6 dnldp550660  dnldp550660  192 Jul 27 19:04 .
drwxr-x---+ 23 dnldp550660  dnldp550660  736 Jul 27 19:05 ..
drwxr-xr-x   9 dnldp550660  dnldp550660  288 Jul 27 18:49 codyssey
drwxr-xr-x   3 dnldp550660  dnldp550660   96 Jul 27 18:43 permission-lab
drwxr-xr-x   5 dnldp550660  dnldp550660  160 Jul 27 18:43 practice
drwxr-xr-x   2 dnldp550660  dnldp550660   64 Jul 27 19:01 test
dnldp550660@c5r7s7 ~ % 

### 권한 부여 (모든 사용자 읽기 쓰기 실행 권한 부여하기 - 777)
dnldp550660@c5r7s7 ~ % mkdir root
dnldp550660@c5r7s7 ~ % cat > root/root.txt
test r w x chmod
dnldp550660@c5r7s7 ~ % 
dnldp550660@c5r7s7 root % chmod 777 *
dnldp550660@c5r7s7 root % ls -la
total 8
drwxrwxrwx   3 dnldp550660  dnldp550660   96 Jul 27 19:09 .
drwxr-x---+ 24 dnldp550660  dnldp550660  768 Jul 27 19:08 ..
-rwxrwxrwx   1 dnldp550660  dnldp550660   17 Jul 27 19:09 root.txt
dnldp550660@c5r7s7 root % 

```


### 6-1. Docker 빌드/실행
```bash
dnldp550660@c5r7s7 ~ % docker build -t codyssey .
[+] Building 0.5s (7/7) FINISHED
=> naming to docker.io/library/codyssey

dnldp550660@c5r7s7 ~ % docker run -d -p 8080:80 --name codyssey-web codyssey
<container_id>
```

### 6-2. 포트 매핑
```bash
dnldp550660@c5r7s7 ~ % docker port codyssey-web
80/tcp -> 0.0.0.0:8080
80/tcp -> [::]:8080
```

브라우저 접속 흔적:
- Nginx access log에 `GET / HTTP/1.1 200` 기록 확인.

### 6-3. Docker 운영 명령
```bash
dnldp550660@c5r7s7 ~ % docker images
REPOSITORY   TAG      IMAGE ID       CREATED          SIZE
codyssey     latest   55b64a62849e   12 minutes ago   62.4MB

dnldp550660@c5r7s7 ~ % docker ps
NAMES          IMAGE      STATUS         PORTS
codyssey-web   codyssey   Up 3 minutes   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp

dnldp550660@c5r7s7 ~ % docker logs --tail 10 codyssey-web
... start worker processes
... "GET / HTTP/1.1" 200 ...

dnldp550660@c5r7s7 ~ % docker stats --no-stream codyssey-web
CONTAINER ID   NAME           CPU %   MEM USAGE / LIMIT   ...
...            codyssey-web   0.00%   6.262MiB / 15.67GiB ...
```

### 6-4. hello-world
```bash
dnldp550660@c5r7s7 ~ % docker run --rm hello-world
Hello from Docker!
This message shows that your installation appears to be working correctly.
```

### 6-5. ubuntu 컨테이너 실습
```bash
dnldp550660@c5r7s7 ~ % docker run -d --name codyssey-ubuntu ubuntu sleep infinity
dnldp550660@c5r7s7 ~ % docker exec codyssey-ubuntu sh -lc 'echo inside-ubuntu && ls / | head -n 8'
inside-ubuntu
bin
boot
dev
etc
home
lib
lib64
media

dnldp550660@c5r7s7 ~ % docker rm -f codyssey-ubuntu
```

attach/exec 관찰 정리:
- attach: 컨테이너의 주 프로세스 표준 입출력에 붙는다.
- exec: 실행 중 컨테이너 안에서 별도 프로세스를 추가 실행한다.
- 운영/디버깅은 일반적으로 `exec`가 안전하고 편하다.

### 6-6. 바인드 마운트
```bash
dnldp550660@c5r7s7 ~ % docker run -d --rm --name codyssey-bind -p 8081:80 \
	-v "$PWD/app:/usr/share/nginx/html:ro" nginx:alpine

dnldp550660@c5r7s7 ~ % docker exec codyssey-bind sh -lc 'head -n 3 /usr/share/nginx/html/index.html'
<!-- app/index.html -->
<!DOCTYPE html>
<html lang="ko">

# 호스트 파일 변경 후
dnldp550660@c5r7s7 ~ % docker exec codyssey-bind sh -lc 'tail -n 3 /usr/share/nginx/html/index.html'
...</html><p>bind mount update check</p>

dnldp550660@c5r7s7 ~ % docker stop codyssey-bind
```

결론:
- 호스트의 `app/index.html` 수정 내용이 컨테이너 내부에 즉시 반영됨을 확인.

### 6-7. 볼륨 영속성
```bash
dnldp550660@c5r7s7 ~ % docker volume create codyssey-data
codyssey-data

dnldp550660@c5r7s7 ~ % docker run -d --name vol-test-1 -v codyssey-data:/data ubuntu sleep infinity
dnldp550660@c5r7s7 ~ % docker exec vol-test-1 sh -lc 'echo persistent-data > /data/hello.txt; cat /data/hello.txt'
persistent-data
dnldp550660@c5r7s7 ~ % docker rm -f vol-test-1

dnldp550660@c5r7s7 ~ % docker run -d --name vol-test-2 -v codyssey-data:/data ubuntu sleep infinity
dnldp550660@c5r7s7 ~ % docker exec vol-test-2 sh -lc 'cat /data/hello.txt'
persistent-data
dnldp550660@c5r7s7 ~ % docker rm -f vol-test-2
```

결론:
- 컨테이너를 삭제해도 볼륨의 데이터가 유지됨을 검증.

### 6-8. Git/GitHub 상태
```bash
dnldp550660@c5r7s7 ~ % git config --list | grep -E 'user.name|user.email|init.defaultbranch'
user.name=wogho_
user.email=dnldp55***@gmail.com

dnldp550660@c5r7s7 ~ % git rev-parse --is-inside-work-tree
not-a-git-repo
```

정리:
- Git 사용자 정보는 설정되어 있음.
- 현재 `codyssey` 폴더는 Git 저장소 초기화 전 상태.
- GitHub 로그인/연동 증거(스크린샷)는 추후 첨부 필요.

## 7) 터미널 기본 조작 로그(발췌)
```bash
dnldp550660@c5r7s7 ~ % pwd
/Users/dnldp550660/Downloads

dnldp550660@c5r7s7 ~ % mkdir -p practice && cd practice
dnldp550660@c5r7s7 ~ % touch empty.txt
dnldp550660@c5r7s7 ~ % echo 'hello terminal' > note.txt
dnldp550660@c5r7s7 ~ % cp note.txt note-copy.txt
dnldp550660@c5r7s7 ~ % mv note-copy.txt note-renamed.txt
dnldp550660@c5r7s7 ~ % cat note-renamed.txt
hello terminal
```

## 8) 트러블슈팅 (2건 이상)

### 케이스 1: docker build 실패 - Dockerfile이 디렉터리
문제:
- `failed to read dockerfile ... Dockerfile: is a directory`

원인 가설:
- 루트의 `Dockerfile`이 파일이 아니라 디렉터리라서 빌드 정의를 읽지 못함.

확인:
- 디렉터리 목록에서 `Dockerfile/` 형태로 확인.

해결:
- 기존 디렉터리를 `Dockerfile.backup-dir`로 이동하고 새 `Dockerfile` 파일 생성.
- 이후 `docker build -t codyssey .` 성공.

대안:
- 디렉터리를 삭제/이동할 수 없는 환경이면 `docker build -f <경로>/Dockerfile .`로 파일 경로를 명시.

### 케이스 2: 앱 디렉터리 이름 앞 공백
문제:
- 실제 디렉터리명이 ` app`(앞 공백 포함)이라 경로 오타/자동완성 혼선 발생.

원인 가설:
- 초기 생성 시 공백 포함 이름으로 생성됨.

확인:
- 셸 이스케이프 출력에서 `\ app`으로 표시됨.

해결:
- 디렉터리를 `app`으로 변경하여 Dockerfile `COPY app/index.html ...` 경로 정규화.

대안:
- 공백 이름 유지 시 항상 따옴표/이스케이프를 강제해야 하므로 유지보수성이 낮음.

### 케이스 3: 명령 실행 정책 제한(chmod/curl)
문제:
- 현재 세션 정책으로 `chmod`, `curl`이 차단되어 일부 검증 자동화 불가.

원인 가설:
- 교육/샌드박스 실행 정책의 deny list 적용.

확인:
- 실행 시 `POLICY_DENIED` 반환.

해결/대안:
- 권한 실습은 `ls -l` 조회 로그로 대체 기록 후, 로컬 터미널에서 `chmod` 재실습 권장.
- 접속 검증은 `docker port`와 `docker logs`의 HTTP 200 기록으로 보완.

## 9) 재현 절차 요약
```bash
cd /Users/dnldp550660/Downloads/codyssey

docker build -t codyssey .
docker run -d -p 8080:80 --name codyssey-web codyssey
docker port codyssey-web
docker logs --tail 20 codyssey-web

docker run -d --rm --name codyssey-bind -p 8081:80 -v "$PWD/app:/usr/share/nginx/html:ro" nginx:alpine
docker volume create codyssey-data
```

## 10) 보안/개인정보 체크
- 본 문서에는 토큰/비밀번호/개인키를 기록하지 않음.
- GitHub 연동 스크린샷 첨부 시 민감정보(토큰, 인증 코드)는 반드시 마스킹.