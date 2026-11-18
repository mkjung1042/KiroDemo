#!/bin/sh
set -eu

cd "$(dirname "$0")/frontend" || exit 1
for asset in index.html policies.json personas.json; do
  if [ ! -f "$asset" ]; then
    printf 'frontend 폴더에서 %s 파일을 찾을 수 없어요. 프로젝트 전체를 압축 해제해 주세요.\n' "$asset" >&2
    exit 1
  fi
done

if ! command -v python3 >/dev/null 2>&1; then
  printf '실행하려면 Mac에 Python 3를 설치한 뒤 다시 열어 주세요.\n' >&2
  exit 1
fi

exec python3 -B - <<'PYTHON'
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
import webbrowser

with ThreadingHTTPServer(("127.0.0.1", 0), SimpleHTTPRequestHandler) as server:
    url = f"http://127.0.0.1:{server.server_port}/"
    print(f"청년혜택 찾기: {url}", flush=True)
    print("브라우저가 열리지 않으면 위 주소로 접속하세요. 종료하려면 Control+C를 누르세요.", flush=True)
    try:
        webbrowser.open(url)
        server.serve_forever()
    except KeyboardInterrupt:
        pass
PYTHON
