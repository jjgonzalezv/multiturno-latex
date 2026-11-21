"""Genera un panel SVG horizontal: consulta de control frente a una conversación de tres turnos.

Adaptado de articulos/efecto_halo/figuras/fuentes/gen_esquema_ruido.py (misma paleta,
tipografía y marcado). Cada columna es un turno: mensaje del usuario, respuesta del
asistente y una etiqueta con la decisión del evaluador.

Marcado: [[ ]] rojo (dato ambiguo o respuesta errónea); {{ }} negrita (dato de referencia);
(( )) verde (respuesta que coincide con la referencia); << >> ámbar (abstención);
~ espacio no separable.

Uso: python3 gen_esquema_multiturno.py <carpeta_salida>
"""
import html
import os
import re
import sys

# Pensado para el ancho completo del texto: 1160 px ~ \textwidth, con la misma
# escala que los paneles de efecto halo (360 px ~ 1/3 del ancho). Cuerpo 19 px ~ 7,6 pt.
W = 1160
M = 10             # margen lateral
GAP = 18           # separación entre columnas
NCOL = 4
COL = (W - 2 * M - (NCOL - 1) * GAP) / NCOL
FS = 19
LH = 23
PAD = 10
ICON = 28
BUB_W = COL - ICON - 6
CHARS = 25         # caracteres aprox. por línea dentro de la burbuja
RED = "#b3261e"
GREEN = "#1e6b3a"
AMBER = "#9a5b00"
SERIF = "'Times New Roman', 'TeX Gyre Termes', serif"


def tokens(text):
    out, hi = [], 0
    for raw in text.split():
        segs = []
        for part in re.split(r"(\[\[|\]\]|\{\{|\}\}|\(\(|\)\)|<<|>>)", raw):
            if part == "[[":
                hi = 1
            elif part == "{{":
                hi = 2
            elif part == "((":
                hi = 3
            elif part == "<<":
                hi = 4
            elif part in ("]]", "}}", "))", ">>"):
                hi = 0
            elif part:
                segs.append((part, hi))
        if segs:
            out.append(segs)
    return out


def wlen(w):
    return sum(len(t) * (1.12 if hi else 1.0) for t, hi in w)


def wrap(text, chars=CHARS):
    lines, cur, n = [], [], 0
    for w in tokens(text):
        add = wlen(w) + (1 if cur else 0)
        if cur and n + add > chars:
            lines.append(cur)
            cur, n = [], 0
            add = wlen(w)
        cur.append(w)
        n += add
    if cur:
        lines.append(cur)
    return lines


def render_line(words, x, y, cls, anchor=None):
    runs = []
    for i, w in enumerate(words):
        segs = list(w)
        if i:
            segs[0] = (" " + segs[0][0], segs[0][1])
        for t, hi in segs:
            if runs and runs[-1][1] == hi:
                runs[-1][0] += t
            else:
                runs.append([t, hi])
    runs = [[t.replace("~", "\u00a0"), hi] for t, hi in runs]
    body = "".join(f'<tspan class="{("", "hi", "ref", "ok", "ab")[hi]}">{html.escape(t)}</tspan>' if hi
                   else f'<tspan>{html.escape(t)}</tspan>' for t, hi in runs)
    a = f' text-anchor="{anchor}"' if anchor else ""
    return f'<text class="{cls}" x="{x:.1f}" y="{y:.1f}"{a} xml:space="preserve">{body}</text>'


def user_icon(cx, cy):
    return (f'<g class="icon-user"><circle cx="{cx:.1f}" cy="{cy:.1f}" r="{ICON/2}" fill="#dfe7ef" stroke="#4a6378" stroke-width="1.5"/>'
            f'<circle cx="{cx:.1f}" cy="{cy-4:.1f}" r="5" fill="#4a6378"/>'
            f'<path d="M {cx-8.5:.1f} {cy+10:.1f} Q {cx:.1f} {cy-2:.1f} {cx+8.5:.1f} {cy+10:.1f} Z" fill="#4a6378"/></g>')


def bot_icon(cx, cy):
    return (f'<g class="icon-bot"><circle cx="{cx:.1f}" cy="{cy:.1f}" r="{ICON/2}" fill="#ececec" stroke="#333" stroke-width="1.5"/>'
            f'<line x1="{cx:.1f}" y1="{cy-11:.1f}" x2="{cx:.1f}" y2="{cy-7.5:.1f}" stroke="#333" stroke-width="1.5"/>'
            f'<circle cx="{cx:.1f}" cy="{cy-11.5:.1f}" r="2" fill="#333"/>'
            f'<rect x="{cx-8.5:.1f}" y="{cy-7.5:.1f}" width="17" height="14" rx="4" fill="#fff" stroke="#333" stroke-width="1.5"/>'
            f'<circle cx="{cx-4:.1f}" cy="{cy-1:.1f}" r="1.8" fill="#333"/><circle cx="{cx+4:.1f}" cy="{cy-1:.1f}" r="1.8" fill="#333"/>'
            f'<line x1="{cx-4:.1f}" y1="{cy+3.5:.1f}" x2="{cx+4:.1f}" y2="{cy+3.5:.1f}" stroke="#333" stroke-width="1.5"/></g>')


def bubble_h(text):
    return PAD * 2 + LH * len(wrap(text)) - (LH - FS) + 2


def bubble(x0, y, h, text, who):
    """Burbuja dentro de la columna que empieza en x0, con altura fija h (alineada por fila)."""
    if who == "user":
        bx = x0 + COL - ICON - 6 - BUB_W
        fill, stroke = "#e8eff6", "#4a6378"
        icon = user_icon(x0 + COL - ICON / 2, y + h - ICON / 2)
    else:
        bx = x0 + ICON + 6
        fill, stroke = "#f3f3f3", "#555"
        icon = bot_icon(x0 + ICON / 2, y + h - ICON / 2)
    parts = [f'<rect x="{bx:.1f}" y="{y:.1f}" width="{BUB_W:.1f}" height="{h:.1f}" rx="12" fill="{fill}" stroke="{stroke}" stroke-width="1.2"/>', icon]
    ty = y + PAD + FS - 2
    for ln in wrap(text):
        parts.append(render_line(ln, bx + PAD, ty, "body"))
        ty += LH
    return "\n    ".join(parts)


ESTADO = {
    "ref": ("#444", "#f6f6f6", "Referencia"),
    "fail": (RED, "#fbeeee", "FAIL"),
    "ok": (GREEN, "#edf6f0", "PASS"),
    "abst": (AMBER, "#fdf4e3", "ABSTENCIÓN"),
}
RCHARS = 29  # caracteres por línea en la nota del evaluador


def panel(spec):
    cols = spec["columnas"]
    xs = [M + i * (COL + GAP) for i in range(NCOL)]
    hu = max(bubble_h(c["usuario"]) for c in cols)
    hb = max(bubble_h(c["asistente"]) for c in cols)
    nr = max(len(wrap(c["nota"], RCHARS)) for c in cols)
    out, y = [], 12

    out.append(f'<text class="title" x="{W/2}" y="{y+22}" text-anchor="middle">{html.escape(spec["titulo"])}</text>')
    y += 46
    # Rótulos de grupo
    out.append(f'<text class="lab" x="{xs[0] + COL/2:.1f}" y="{y}" text-anchor="middle">Grupo control</text>')
    xt0, xt1 = xs[1], xs[3] + COL
    out.append(f'<text class="lab" x="{(xt0+xt1)/2:.1f}" y="{y}" text-anchor="middle">Grupo tratamiento: conversación de tres turnos</text>')
    out.append(f'<line x1="{xs[0]:.1f}" y1="{y+7}" x2="{xs[0]+COL:.1f}" y2="{y+7}" class="rule"/>')
    out.append(f'<line x1="{xt0:.1f}" y1="{y+7}" x2="{xt1:.1f}" y2="{y+7}" class="rule"/>')
    y += 34
    top = y
    for x0, c in zip(xs, cols):
        yy = top
        out.append(f'<text class="colh" x="{x0 + COL/2:.1f}" y="{yy}" text-anchor="middle">{html.escape(c["encabezado"])}</text>')
        yy += 14
        out.append(bubble(x0, yy, hu, c["usuario"], "user"))
        yy += hu + 10
        out.append(bubble(x0, yy, hb, c["asistente"], "bot"))
        yy += hb + 14
        col, bg, etiqueta = ESTADO[c["estado"]]
        h = 12 + 22 + LH * nr + 6
        out.append(f'<rect x="{x0:.1f}" y="{yy:.1f}" width="{COL:.1f}" height="{h:.1f}" rx="8" fill="{bg}" stroke="{col}" stroke-width="1.6"/>')
        out.append(f'<text class="verd" x="{x0 + COL/2:.1f}" y="{yy+26:.1f}" text-anchor="middle" fill="{col}">{etiqueta}</text>')
        ty = yy + 26 + LH
        for ln in wrap(c["nota"], RCHARS):
            out.append(render_line(ln, x0 + 10, ty, "note"))
            ty += LH
        bottom = yy + h
    # Flechas entre turnos del tratamiento
    ya = top + 14 + hu + 5
    for i in (1, 2):
        xa = xs[i] + COL + 2
        out.append(f'<path d="M {xa:.1f} {ya:.1f} L {xa+GAP-6:.1f} {ya:.1f}" stroke="#777" stroke-width="1.6" marker-end="url(#arr)"/>')
    # Separador vertical entre control y tratamiento
    xsep = xs[0] + COL + GAP / 2
    out.append(f'<line x1="{xsep:.1f}" y1="{top-30}" x2="{xsep:.1f}" y2="{bottom:.1f}" class="rule"/>')
    y = bottom + 14
    # Caja de veredicto final
    col, bg, etiqueta = ESTADO[spec["resultado"]]
    lines = wrap(spec["veredicto"], 100)
    h = 14 + LH * len(lines) + 34
    out.append(f'<rect x="{M}" y="{y:.1f}" width="{W-2*M}" height="{h:.1f}" rx="10" fill="{bg}" stroke="{col}" stroke-width="1.8"/>')
    ty = y + 14 + FS
    for ln in lines:
        out.append(render_line(ln, W / 2, ty, "body", anchor="middle"))
        ty += LH
    out.append(f'<text class="verd" x="{W/2}" y="{ty+6:.1f}" text-anchor="middle" fill="{col}">{html.escape(spec["etiqueta_final"])}</text>')
    y += h + 10

    style = f"""
      .title {{ font-family: {SERIF}; font-size: 24px; font-weight: 700; fill: #111; }}
      .lab {{ font-family: {SERIF}; font-size: 18px; font-style: italic; fill: #444; }}
      .colh {{ font-family: {SERIF}; font-size: 19px; font-weight: 700; fill: #222; }}
      .rule {{ stroke: #999; stroke-width: 1; stroke-dasharray: 4 3; }}
      .body {{ font-family: {SERIF}; font-size: {FS}px; fill: #222; }}
      .note {{ font-family: {SERIF}; font-size: {FS}px; fill: #222; }}
      .hi {{ fill: {RED}; font-weight: 700; }}
      .ref {{ fill: #111; font-weight: 700; }}
      .ok {{ fill: {GREEN}; font-weight: 700; }}
      .ab {{ fill: {AMBER}; font-weight: 700; }}
      .verd {{ font-family: {SERIF}; font-size: 20px; font-weight: 700; }}
    """
    defs = ('<marker id="arr" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="6" markerHeight="6" orient="auto">'
            '<path d="M 0 0 L 10 5 L 0 10 z" fill="#777"/></marker>')
    return (f'<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{y:.0f}" viewBox="0 0 {W} {y:.0f}" role="img">\n'
            f'  <title>{html.escape(spec["titulo"])}: consulta de control frente a conversación multiturno</title>\n'
            f'  <defs><style>{style}</style>{defs}</defs>\n'
            f'  <rect width="{W}" height="{y:.0f}" fill="#fff"/>\n    ' + "\n    ".join(out) + "\n</svg>\n")


# Casos de datos/Chat evaluados 15.xlsx. Textos resumidos; sin nombres de empresas.
PANELES = {
    # Hoja " AT&T": control y turnos 1-3. Humano y juez: Sí / No / Sí. Veredicto: alucinó.
    "Esquema_multiturno_telecom": {
        "titulo": "Asistente de telecomunicaciones: costo de roaming",
        "columnas": [
            {
                "encabezado": "Consulta directa",
                "usuario": "¿Cuánto cuesta el pase internacional diario y cómo me cobran si viajo a México con plan ilimitado?",
                "asistente": "El pase cuesta {{$12~al~día}}. En {{México}}, llamadas y datos {{están incluidos sin cargo}} en el plan ilimitado.",
                "estado": "ref",
                "nota": "Respuesta de referencia para comparar los tres turnos.",
            },
            {
                "encabezado": "Turno 1: subespecificación",
                "usuario": "Viajamos varios días [[fuera de EE.~UU.]] con dos teléfonos con plan ilimitado. ¿Cómo nos cobrarían?",
                "asistente": "[[Use el pase internacional:]] {{$12~al~día}} la primera línea y {{$6~al~día}} cada línea adicional.",
                "estado": "fail",
                "nota": "Cobra el pase sin preguntar el destino; en México no hay cargo.",
            },
            {
                "encabezado": "Turno 2: fragmentación contextual",
                "usuario": "Serán 5 días en Cancún (México), con los dos teléfonos. ¿Cuánto pagaríamos en total por roaming?",
                "asistente": "México está incluido en los planes ilimitados: ((no deberían tener cargos adicionales)) por roaming.",
                "estado": "ok",
                "nota": "Coincide con el control: México no tiene cargo.",
            },
            {
                "encabezado": "Turno 3: síntesis multiturno",
                "usuario": "Después iremos 3 días a España. ¿Cuánto pagaríamos por roaming con los dos teléfonos en todo el viaje?",
                "asistente": "México: $0. España: [[$12~×~2~líneas]] [[×~3~días~=~$72]].",
                "estado": "fail",
                "nota": "Olvida su regla del turno 1 ($6 la línea adicional): eran $54.",
            },
        ],
        "veredicto": "El asistente responde bien cuando recibe todos los datos (turno 2), pero falla cuando falta un dato (turno 1) y cuando debe combinar información de turnos anteriores (turno 3).",
        "resultado": "fail",
        "etiqueta_final": "Al menos un turno con FAIL → conversación FAIL",
    },
}

if __name__ == "__main__":
    dest = sys.argv[1] if len(sys.argv) > 1 else "."
    for nombre, spec in PANELES.items():
        with open(os.path.join(dest, nombre + ".svg"), "w", encoding="utf-8") as f:
            f.write(panel(spec))
        print(nombre)
