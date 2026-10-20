"""Rebuild: nix-shell -p 'python3.withPackages (ps: [ ps.fonttools ])' --run 'python3 tools/build-sidebar-icons.py'"""

from pathlib import Path
from urllib.request import urlopen
import xml.etree.ElementTree as ET

from fontTools.fontBuilder import FontBuilder
from fontTools.pens.cu2quPen import Cu2QuPen
from fontTools.pens.transformPen import TransformPen
from fontTools.pens.ttGlyphPen import TTGlyphPen
from fontTools.svgLib.path import parse_path


ROOT = Path(__file__).resolve().parents[1]
CDN = "https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@7.0.1/svgs"
sources = {
    "github": urlopen(f"{CDN}/brands/github.svg").read(),
    "twitter": urlopen(f"{CDN}/brands/x-twitter.svg").read(),
    "email": urlopen(f"{CDN}/solid/envelope.svg").read(),
    "tryhackme": (ROOT / "_includes/icons/tryhackme.svg").read_bytes(),
}
glyphs = {".notdef": TTGlyphPen(None).glyph()}
for name, source in sources.items():
    svg = ET.fromstring(source)
    x, y, width, height = map(float, svg.attrib["viewBox"].split())
    scale = 1000 / max(width, height)
    pen = TTGlyphPen(None)
    outline = TransformPen(Cu2QuPen(pen, 1, reverse_direction=True),
                           (scale, 0, 0, -scale, (1000 - width * scale) / 2 - x * scale, 850 + y * scale))
    for path in svg.findall(".//{http://www.w3.org/2000/svg}path"):
        parse_path(path.attrib["d"], outline)
    glyphs[name] = pen.glyph()

font = FontBuilder(1000, isTTF=True)
font.setupGlyphOrder(list(glyphs))
font.setupCharacterMap({0xF09B: "github", 0xE61B: "twitter", 0xF0E0: "email", 0xE000: "tryhackme"})
font.setupGlyf(glyphs)
font.setupHorizontalMetrics({name: (1000, 0) for name in glyphs})
font.setupHorizontalHeader(ascent=850, descent=-150)
font.setupNameTable({"familyName": "Sidebar Icons", "styleName": "Regular", "uniqueFontIdentifier": "Sidebar Icons 1", "fullName": "Sidebar Icons", "psName": "SidebarIcons"})
font.setupOS2(sTypoAscender=850, sTypoDescender=-150, usWinAscent=850, usWinDescent=150)
font.setupPost()
font.save(ROOT / "assets/fonts/sidebar-icons.ttf")
