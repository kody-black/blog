"""Check generated HTML links and assets without requesting external websites."""
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import unquote, urljoin, urlsplit
import sys

root = Path(sys.argv[1] if len(sys.argv) > 1 else "public").resolve()
base = sys.argv[2] if len(sys.argv) > 2 else "https://kody-black.github.io/blog/"
site = urlsplit(base)
errors = set()


class Links(HTMLParser):
    def handle_starttag(self, tag, attrs):
        for key, value in attrs:
            if key not in ("href", "src", "poster") or not value:
                continue
            url = urlsplit(urljoin(page_url, value))
            if url.scheme not in ("http", "https") or url.netloc != site.netloc:
                continue
            # Historical links to the separate old blog are intentional.
            if value.startswith("https://kody-black.github.io/oldblog/"):
                continue
            if not url.path.startswith(site.path):
                errors.add(f"{relative}: outside site prefix: {value}")
                continue
            target = root / unquote(url.path[len(site.path):])
            if not target.is_file() and not (target / "index.html").is_file():
                errors.add(f"{relative}: missing target: {value}")


pages = list(root.rglob("*.html"))
if not pages:
    sys.exit("No generated HTML found; run Hugo first.")
for page in pages:
    relative = page.relative_to(root).as_posix()
    page_url = urljoin(base, relative.removesuffix("index.html"))
    Links().feed(page.read_text(encoding="utf-8"))
for error in sorted(errors):
    print(error)
print(f"Checked {len(pages)} HTML files; {len(errors)} broken internal links/assets.")
sys.exit(bool(errors))
