<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" style="height:64px;margin-right:32px"/>

# "session_timeout": 300 // Logout na 5 minuten inactiviteit

Kan ik dit instellen in mijn HA add on voor Open Web-ui?

Ja, je kunt de session timeout configureren in Open WebUI, maar de instelling die je noemt (300 seconden) is **niet** specifiek voor gebruikerssessies maar voor API-timeouts. Voor het instellen van de daadwerkelijke uitlog-timeout na inactiviteit moet je een andere configuratie gebruiken.[^1_1]

## JWT Token Expiratie

Open WebUI gebruikt JWT (JSON Web Token) tokens voor sessiemanagement. Je kunt de sessieduur configureren via de volgende omgevingsvariabele:[^1_2]

**`JWT_EXPIRES_IN`**

- Type: integer (seconden) of tijdsnotatie zoals "30m", "1h", "7d"
- Standaard: -1 (geen expiratie)
- Functie: bepaalt hoe lang een gebruiker ingelogd blijft[^1_3][^1_2]

Voor 5 minuten inactiviteit zou je dus moeten instellen:

```
JWT_EXPIRES_IN=300
```

of

```
JWT_EXPIRES_IN=5m
```


## Configuratie in Home Assistant Add-on

In de Home Assistant add-on voor Open WebUI kun je dit instellen via de add-on configuratie:

1. Ga naar **Supervisor** → **Add-ons** → **Open WebUI**
2. Klik op het **Configuration** tabblad
3. Voeg de omgevingsvariabele toe aan de configuratie
4. Herstart de add-on

Let op: De standaardwaarde van -1 betekent dat tokens niet verlopen. Het instellen van een korte expiratie zoals 300 seconden kan gebruikersonvriendelijk zijn, omdat gebruikers dan tijdens langere gesprekken uitgelogd worden.[^1_4][^1_5][^1_2]
<span style="display:none">[^1_10][^1_11][^1_12][^1_13][^1_14][^1_15][^1_16][^1_17][^1_18][^1_19][^1_6][^1_7][^1_8][^1_9]</span>

<div align="center">⁂</div>

[^1_1]: https://docs.openwebui.com/getting-started/env-configuration/

[^1_2]: https://github.com/open-webui/docs/blob/main/docs/features/jwttoken.md

[^1_3]: https://deepwiki.com/open-webui/open-webui/11.4-session-management

[^1_4]: https://www.reddit.com/r/OpenWebUI/comments/1ihe3ch/web_session_length/

[^1_5]: https://deepwiki.com/open-webui/open-webui/10-authentication-and-access-control

[^1_6]: https://how-to.aimms.com/Articles/342/342-WebUI-Session-Timeout-Extension.html

[^1_7]: https://github.com/TheRealPSV/ha-openwebui-conversation

[^1_8]: https://forum.proxmox.com/threads/webui-api-logged-out-every-5-minutes.109066/

[^1_9]: https://www.reddit.com/r/homeassistant/comments/1f4opgt/is_there_a_way_to_set_a_timeout_that_defaults_ha/

[^1_10]: https://forum.bigfix.com/t/how-to-disable-webui-session-timeout/25221

[^1_11]: https://community.home-assistant.io/t/to-open-add-on-web-ui-using-ip-instead-of-domain/549072

[^1_12]: https://www.reddit.com/r/OpenWebUI/comments/1fz66xm/openwebui_timing_out_issue/

[^1_13]: https://scognito.wordpress.com/2020/11/09/home-assistant-first-add-ons-and-configurations/

[^1_14]: https://github.com/open-webui/open-webui/issues/566

[^1_15]: https://aliceo2group.github.io/WebUi/Framework/docs/guide/json-tokens.html

[^1_16]: https://github.com/open-webui/open-webui/issues/5866

[^1_17]: https://tjbck.github.io/docs/getting-started/env-configuration/

[^1_18]: https://openwebui.codelin.vip/en/getting-started/env-configuration/

[^1_19]: https://github.com/open-webui/docs/blob/main/docs/getting-started/advanced-topics/env-configuration.md


---

# ik kan geen configuratie instellen voor wb-ui in het tabblad configuratie. Ik kan daar alleen de poort wijizgen

Je hebt gelijk - in veel Home Assistant add-ons kun je alleen de basis opties configureren via het Configuration tabblad, niet de volledige Docker omgevingsvariabelen. Dit is een beperking van hoe Home Assistant add-ons zijn opgezet.[^2_1][^2_2]

## Oplossingen

### Optie 1: Controleer de add-on documentatie

Sommige Open WebUI add-ons voor Home Assistant hebben mogelijk een aangepaste `options.json` configuratie die JWT-instellingen ondersteunt. Kijk in de add-on documentatie of er specifieke configuratieopties zijn voor sessie-instellingen.

### Optie 2: Custom add-on aanpassen

Als je een community add-on gebruikt, kun je de add-on zelf aanpassen:

1. Zoek de add-on bestanden in `/addon_configs/` of via SSH
2. Bewerk het `config.yaml` (of `config.json`) bestand van de add-on
3. Voeg de environment variabele toe aan de `environment:` sectie:
```yaml
environment:
  JWT_EXPIRES_IN: "300"
```


### Optie 3: Open WebUI als Docker container

Als alternatief kun je Open WebUI als losse Docker container draaien in plaats van als Home Assistant add-on. Dan heb je volledige controle over omgevingsvariabelen via een `docker-compose.yaml`:[^2_3]

```yaml
environment:
  - JWT_EXPIRES_IN=300
  - ENABLE_PERSISTENT_CONFIG=false
```


### Optie 4: Configuratie via de webinterface

Als `ENABLE_PERSISTENT_CONFIG` is ingeschakeld (standaard), kun je mogelijk sommige instellingen aanpassen via de Open WebUI admin interface zelf, hoewel `JWT_EXPIRES_IN` mogelijk niet beschikbaar is in de UI.[^2_4][^2_5]

Home Assistant add-ons hebben beperkte configuratiemogelijkheden omdat ze via `options.json` werken in plaats van directe Docker environment variables.[^2_6][^2_2]
<span style="display:none">[^2_10][^2_11][^2_12][^2_13][^2_14][^2_15][^2_16][^2_17][^2_7][^2_8][^2_9]</span>

<div align="center">⁂</div>

[^2_1]: https://community.home-assistant.io/t/how-to-set-environment-variables-for-hass-io/732871

[^2_2]: https://github.com/home-assistant/hassio/issues/805

[^2_3]: https://github.com/Athozs/hass-environment-variable

[^2_4]: https://github.com/open-webui/open-webui/discussions/18991

[^2_5]: https://github.com/open-webui/docs/blob/main/docs/getting-started/env-configuration.md

[^2_6]: https://github.com/home-assistant/supervisor/issues/805

[^2_7]: https://docs.openwebui.com/getting-started/env-configuration/

[^2_8]: https://community.home-assistant.io/t/to-open-add-on-web-ui-using-ip-instead-of-domain/549072

[^2_9]: https://developers.home-assistant.io/docs/apps/configuration/

[^2_10]: https://www.home-assistant.io/docs/configuration/

[^2_11]: https://yaml.cc/qa/how-to-access-configuration-yaml-home-assistant.html

[^2_12]: https://github.com/home-assistant/addons

[^2_13]: https://community.home-assistant.io/t/passing-add-on-config-data-to-docker-image-as-env-var-on-start/112835

[^2_14]: https://community.home-assistant.io/t/addon-development-use-options-fields-as-environment-variable-in-config-yaml/874079

[^2_15]: https://home-assistant-china.github.io/developers/hassio/addon_config/

[^2_16]: https://www.reddit.com/r/homeassistant/comments/1gnw84z/help_wanted_to_turn_docker_container_into_home/

[^2_17]: https://developers.home-assistant.io/docs/add-ons/configuration/


---

# Ik heb deze add-on:

[https://github.com/mikastamm/open-webui-homeassistant-addon](https://github.com/mikastamm/open-webui-homeassistant-addon)

Waar vind ik de config file die gebruikt wordt? Niet kunnen vinden...

Voor de mikastamm Open WebUI Home Assistant add-on vind je de configuratiebestanden op de volgende locaties:

## Locatie van add-on configuratiebestanden

### Via SSH (aanbevolen)

1. **Installeer "SSH \& Web Terminal" add-on** (als je die nog niet hebt)[^3_1]
2. **Verbind via SSH** met Home Assistant
3. **Navigeer naar de add-on configuratie**:
```bash
cd /addon_configs
```

Hier staan de configuraties van alle add-ons. Zoek naar de map van Open WebUI (waarschijnlijk een naam zoals `local_open_webui` of iets met de slug van de add-on).[^3_2]

### Belangrijke paden in Home Assistant OS:

- `/config` - Algemene Home Assistant configuratie[^3_1][^3_2]
- `/addon_configs` - Configuraties van specifieke add-ons[^3_2]
- `/addons` - Lokale add-on bestanden[^3_2]


## Add-on eigen config.yaml bewerken

Als je de add-on **zelf** wilt aanpassen (niet de runtime configuratie, maar de add-on definitie):

1. Via SSH navigeer naar: `/addons/local/open-webui/` (of vergelijkbare naam)
2. Hier vind je het `config.yaml` bestand van de add-on zelf[^3_3][^3_4]
3. In dit bestand kun je de `environment:` sectie toevoegen:
```yaml
environment:
  JWT_EXPIRES_IN: "300"
```

**Let op**: Wijzigingen aan `/addons/` vereisen vaak een herstart van de Supervisor of volledige herinstallatie van de add-on.

Voor de mikastamm add-on moet je mogelijk de GitHub repository clonen en lokaal als custom add-on installeren om volledige controle te hebben over environment variables.[^3_4]
<span style="display:none">[^3_5][^3_6][^3_7][^3_8][^3_9]</span>

<div align="center">⁂</div>

[^3_1]: https://yaml.cc/qa/how-to-access-configuration-yaml-home-assistant.html

[^3_2]: https://jirkovynavody.cz/en/homeassistant/configuration/addons/addon_ssh/

[^3_3]: https://github.com/home-assistant/addons-example/blob/main/example/config.yaml

[^3_4]: https://developers.home-assistant.io/docs/add-ons/configuration/

[^3_5]: https://www.reddit.com/r/homeassistant/comments/1g6kifw/i_wrote_another_guide_this_time_on_how_to/

[^3_6]: https://developers.home-assistant.io/docs/apps/configuration/

[^3_7]: https://stratobuilds.com/project/local-llm-ollama-home-assistant/

[^3_8]: https://www.home-assistant.io/docs/configuration/

[^3_9]: https://www.reddit.com/r/homeassistant/comments/c5yqwh/where_is_my_config_directory/


---

# nee staat het allemaal niet. misschien via addon_4d14bf22_openwebui docker exec?

Ja, je bent op het goede spoor! Je kunt via `docker exec` in de container komen, maar **environment variables toevoegen via docker exec werkt niet permanent** - die verdwijnen bij een herstart van de container.[^4_1][^4_2]

## Het probleem met Home Assistant add-ons

Home Assistant add-ons hebben een beperking: environment variables die je via `options.json` instelt zijn **niet automatisch beschikbaar** in de container, tenzij de add-on ontwikkelaar dit expliciet heeft geconfigureerd.[^4_3][^4_1]

## Mogelijke oplossingen

### 1. **Controleer of de add-on een run script heeft**

Kijk of de mikastamm add-on een `run.sh` of startup script heeft dat je kunt aanpassen. Dit zou in de add-on definitie moeten zitten (mogelijk moet je de GitHub repo clonen en als lokale add-on installeren).

### 2. **Gebruik een custom wrapper script**

Als de add-on lokaal is geïnstalleerd, kun je een wrapper script maken dat de environment variable instelt voordat Open WebUI start:

```bash
#!/usr/bin/with-contenv bashio
export JWT_EXPIRES_IN=300
exec /original-start-command
```


### 3. **Open WebUI configuratiebestand**

Open WebUI kan ook via een config bestand worden geconfigureerd. Probeer binnen de container te kijken of er een config file is:

```bash
docker exec addon_4d14bf22_openwebui ls -la /app
docker exec addon_4d14bf22_openwebui ls -la /data
```

Open WebUI gebruikt mogelijk een `.env` bestand of `config.json` in `/data`.[^4_4]

### 4. **Fork de add-on**

De meest betrouwbare oplossing: fork de GitHub repository, voeg de environment variable toe aan het `config.yaml`, en installeer jouw eigen versie als lokale add-on.[^4_3][^4_4]

**Let op**: Docker exec aanpassingen zijn tijdelijk en verdwijnen bij elke container restart.[^4_2]
<span style="display:none">[^4_10][^4_5][^4_6][^4_7][^4_8][^4_9]</span>

<div align="center">⁂</div>

[^4_1]: https://community.home-assistant.io/t/pass-environment-variables-to-addon-containers/766138

[^4_2]: https://community.home-assistant.io/t/docker-compose-environment-variables/283825

[^4_3]: https://github.com/home-assistant/supervisor/issues/805

[^4_4]: https://www.reddit.com/r/homeassistant/comments/1gnw84z/help_wanted_to_turn_docker_container_into_home/

[^4_5]: https://github.com/Athozs/hass-environment-variable

[^4_6]: https://www.influxdata.com/blog/getting-started-home-assistant-docker/

[^4_7]: https://www.reddit.com/r/homeassistant/comments/1lvwix5/monitor_and_control_your_docker_containers_from/

[^4_8]: https://www.home-assistant.io/common-tasks/container/

[^4_9]: https://www.reddit.com/r/homeassistant/comments/m1qpqg/can_docker_containers_for_addons_be_automated/

[^4_10]: https://github.com/ualex73/monitor_docker


---

# homeassistant git:(main) ✗ docker exec addon_4d14bf22_openwebui ls -la /data

total 476
drwxr-xr-x 5 root root   4096 Feb  5 07:26 .
drwxr-xr-x 1 root root   4096 Feb  5 06:47 ..
drwxr-xr-x 4 root root   4096 Feb  5 06:47 cache
-rw------- 1 root root      2 Feb  5 06:47 options.json
drwxr-xr-x 2 root root   4096 Feb  5 06:47 uploads
drwxr-xr-x 2 root root   4096 Feb  5 06:47 vector_db
-rw-r--r-- 1 root root 462848 Feb  5 07:26 webui.db
➜  homeassistant git:(main) ✗ docker exec addon_4d14bf22_openwebui cat /data/options.json
{}\#
➜  homeassistant git:(main) ✗

Ik denk dat dit hem is. Zou jij willen proberen of je een script kan maken wat een echo [inhoud config] > /data/options.json maakt zodat deze inhoud heeft?

Ja, ik kan je helpen met een script! Maar **let op**: `options.json` wordt normaal gesproken door Home Assistant beheerd en kan worden overschreven bij een add-on herstart.[^5_1][^5_2]

Toch kunnen we het proberen. Hier is een script dat de JWT_EXPIRES_IN configuratie toevoegt:

```bash
#!/bin/bash

# Backup maken van origineel
docker exec addon_4d14bf22_openwebui cp /data/options.json /data/options.json.backup

# Nieuwe configuratie met JWT_EXPIRES_IN instellen
docker exec addon_4d14bf22_openwebui sh -c 'echo "{\"JWT_EXPIRES_IN\": \"300\"}" > /data/options.json'

# Controleren of het gelukt is
echo "Nieuwe configuratie:"
docker exec addon_4d14bf22_openwebui cat /data/options.json

# Add-on herstarten (optioneel, vervang met jouw add-on slug)
# ha addons restart 4d14bf22_openwebui
```


## Alternatief: Environment variable direct instellen

Omdat `options.json` leeg is (`{}`), is het waarschijnlijker dat Open WebUI gewoon de standaard environment variables gebruikt. Probeer dit:

```bash
# Controleer huidige environment variables
docker exec addon_4d14bf22_openwebui env | grep JWT

# Probeer een .env bestand te maken in /data
docker exec addon_4d14bf22_openwebui sh -c 'echo "JWT_EXPIRES_IN=300" > /data/.env'

# Of in /app (waar Open WebUI draait)
docker exec addon_4d14bf22_openwebui sh -c 'echo "JWT_EXPIRES_IN=300" > /app/.env'
```

**Waarschuwing**: Deze wijzigingen zijn waarschijnlijk **tijdelijk** en verdwijnen bij een add-on update of herstart. De enige permanente oplossing is de add-on zelf aanpassen via een fork van de GitHub repository.[^5_2][^5_3][^5_1]

Wil je dat ik je help met het forken en aanpassen van de mikastamm add-on voor een permanente oplossing?

<div align="center">⁂</div>

[^5_1]: https://github.com/home-assistant/supervisor/issues/805

[^5_2]: https://community.home-assistant.io/t/pass-environment-variables-to-addon-containers/766138

[^5_3]: https://community.home-assistant.io/t/docker-compose-environment-variables/283825


---

# docker exec addon_4d14bf22_openwebui env | grep JWT

Perfect! Voer dat commando uit en laat me de output zien. Dan kunnen we zien of er al JWT-gerelateerde environment variables zijn ingesteld en wat de huidige waarden zijn.[^6_1][^6_2]

Dit commando laat zien:

- Of `JWT_EXPIRES_IN` al bestaat
- Welke waarde het momenteel heeft
- Andere JWT-configuraties zoals `WEBUI_SECRET_KEY` of `JWT_SECRET_KEY`

Plak de output hier, dan kunnen we verder kijken hoe we de session timeout het beste kunnen configureren!

<div align="center">⁂</div>

[^6_1]: https://github.com/open-webui/docs/blob/main/docs/features/jwttoken.md

[^6_2]: https://deepwiki.com/open-webui/open-webui/11.4-session-management


---

# Je waarschuwing hoef je niet steeds te herhalen hoor. Kappen.

homeassistant git:(main) ✗ docker exec addon_4d14bf22_openwebui env | grep JWT
➜  homeassistant git:(main) ✗ docker exec addon_4d14bf22_openwebui sh -c 'echo "JWT_EXPIRES_IN=300" > /data/.env'
➜  homeassistant git:(main) ✗ docker exec addon_4d14bf22_openwebui env | grep JWT
➜  homeassistant git:(main) ✗ docker exec addon_4d14bf22_openwebui sh -c 'echo "JWT_EXPIRES_IN=300" > /app/.env'
➜  homeassistant git:(main) ✗ docker exec addon_4d14bf22_openwebui env | grep JWT
➜  homeassistant git:(main) ✗ docker exec addon_4d14bf22_openwebui env
PATH=/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOSTNAME=4d14bf22-openwebui
TZ=Europe/Amsterdam
SUPERVISOR_TOKEN=85574a140db4078eb3aca75cc26c2b3fb36f727094be9cdfede9c44e0a4b8ef80dc3a3f48cc8c6e5415aa00c406fdb5e5723793a700fc4cf
HASSIO_TOKEN=85574a140db4078eb3aca75cc26c2b3fb36f727094be9cdfede9c44e0a4b8ef80dc3a3f48cc8c6e5415aa00c406fdb5e5723793a700fc4cf
LANG=C.UTF-8
GPG_KEY=A035C8C19219BA821ECEA86B64E628F8D684696D
PYTHON_VERSION=3.11.14
PYTHON_SHA256=8d3ed8ec5c88c1c95f5e558612a725450d2452813ddad5e58fdb1a53b1209b78
PYTHONUNBUFFERED=1
ENV=prod
PORT=8080
USE_OLLAMA_DOCKER=false
USE_CUDA_DOCKER=false
USE_SLIM_DOCKER=false
USE_CUDA_DOCKER_VER=cu128
USE_EMBEDDING_MODEL_DOCKER=sentence-transformers/all-MiniLM-L6-v2
USE_RERANKING_MODEL_DOCKER=
USE_AUXILIARY_EMBEDDING_MODEL_DOCKER=TaylorAI/bge-micro-v2
OLLAMA_BASE_URL=/ollama
OPENAI_API_BASE_URL=
OPENAI_API_KEY=
WEBUI_SECRET_KEY=
SCARF_NO_ANALYTICS=true
DO_NOT_TRACK=true
ANONYMIZED_TELEMETRY=false
WHISPER_MODEL=base
WHISPER_MODEL_DIR=/app/backend/data/cache/whisper/models
RAG_EMBEDDING_MODEL=sentence-transformers/all-MiniLM-L6-v2
RAG_RERANKING_MODEL=
AUXILIARY_EMBEDDING_MODEL=TaylorAI/bge-micro-v2
SENTENCE_TRANSFORMERS_HOME=/app/backend/data/cache/embedding/models
TIKTOKEN_ENCODING_NAME=cl100k_base
TIKTOKEN_CACHE_DIR=/app/backend/data/cache/tiktoken
HF_HOME=/app/backend/data/cache/embedding/models
HOME=/root
WEBUI_BUILD_VERSION=2b26355002064228e9b671339f8f3fb9d1fafa73
DOCKER=true
DATA_DIR=/data
➜  homeassistant git:(main) ✗

Niet gelukt he?

Klopt, de `.env` bestanden worden niet automatisch ingeladen. Maar ik zie wel nuttige informatie:

De container heeft `DATA_DIR=/data` en `PORT=8080` als environment variables. Open WebUI leest blijkbaar **niet** automatisch `.env` bestanden, maar krijgt environment variables direct van Docker.[^7_1]

## Oplossing: Environment variable direct in container instellen

Probeer dit om te testen of het werkt (tijdelijk, tot herstart):

```bash
# Stop de Open WebUI add-on via Home Assistant UI

# Start container met extra environment variable
docker exec addon_4d14bf22_openwebui sh -c 'export JWT_EXPIRES_IN=300 && /usr/local/bin/python -m uvicorn main:app --host 0.0.0.0 --port 8080'
```

Maar dit zal niet werken omdat de container al draait.

## Echte oplossing: Add-on aanpassen

Je moet de add-on definitie aanpassen. Doe het volgende:

1. **Clone de repository lokaal**:
```bash
cd /addons
git clone https://github.com/mikastamm/open-webui-homeassistant-addon.git local-openwebui
```

2. **Bewerk het `run.sh` of startup script** en voeg toe:
```bash
export JWT_EXPIRES_IN=300
```

3. **Of bewerk `config.yaml`** in de add-on en voeg toe onder `environment:`:
```yaml
environment:
  JWT_EXPIRES_IN: "300"
```

4. **Herinstalleer de add-on** als lokale add-on

Wil je dat ik uitleg hoe je de add-on repository kunt clonen en aanpassen?

<div align="center">⁂</div>

[^7_1]: https://docs.openwebui.com/getting-started/env-configuration/


---

# homeassistant git:(main) ✗ \# Stop de Open WebUI add-on via Home Assistant UI

# Start container met extra environment variable

docker exec addon_4d14bf22_openwebui sh -c 'export JWT_EXPIRES_IN=300 \&\& /usr/local/bin/python -m uvicorn main:app --host 0.0.0.0 --port 8080'

ERROR:    Error loading ASGI app. Could not import module "main".
➜  homeassistant git:(main) ✗

Ah ja, het startup commando klopt niet. Laten we eerst kijken hoe Open WebUI normaal start:

```bash
# Bekijk het actieve proces
docker exec addon_4d14bf22_openwebui ps aux

# Of bekijk wat er in /app staat
docker exec addon_4d14bf22_openwebui ls -la /app
```

Voer deze uit, dan kunnen we zien wat het echte startup commando is en waar de applicatie zich bevindt.[^8_1]

<div align="center">⁂</div>

[^8_1]: https://docs.openwebui.com/getting-started/env-configuration/


---

# Kan ik de add-on niet stoppen en dat een commando of script de add on start met extra parameters?

homeassistant git:(main) ✗ docker exec addon_4d14bf22_openwebui ps aux
OCI runtime exec failed: exec failed: unable to start container process: exec: "ps": executable file not found in \$PATH
➜  homeassistant git:(main) ✗ docker exec addon_4d14bf22_openwebui ls -la /app
total 524
drwxr-xr-x 1 root root   4096 Jan 10 22:03 .
drwxr-xr-x 1 root root   4096 Feb  5 07:41 ..
-rw-r--r-- 1 root root 501258 Jan 10 22:00 CHANGELOG.md
drwxr-xr-x 1 root root   4096 Feb  5 07:41 backend
drwxr-xr-x 9 root root   4096 Jan 10 22:03 build
-rw-r--r-- 1 root root   5088 Jan 10 22:00 package.json
➜  homeassistant git:(main) ✗

Nee, dat gaat niet werken. Home Assistant Supervisor beheert de add-on containers en overschrijft elke handmatige start. Je kunt niet zomaar een container stoppen en handmatig met andere parameters opstarten.[^9_1][^9_2]

## De enige werkende oplossing

Je **moet** de add-on definitie zelf aanpassen. Hier is hoe:

### 1. Installeer als lokale add-on

```bash
# Ga naar de local addons directory
cd /addons

# Clone de repository
git clone https://github.com/mikastamm/open-webui-homeassistant-addon.git openwebui-custom

# Ga in de add-on directory
cd openwebui-custom/open-webui
```


### 2. Bewerk `config.yaml`

Zoek naar het bestand en voeg de environment variable toe:

```bash
# Bekijk de huidige config
cat config.yaml

# Voeg JWT_EXPIRES_IN toe aan de environment sectie
```

Voeg dit toe (of bewerk de bestaande `environment:` sectie):

```yaml
environment:
  JWT_EXPIRES_IN: "300"
```


### 3. Herstart Supervisor en installeer

```bash
# Reload supervisor
ha supervisor reload

# Dan via UI: Settings → Add-ons → Add-on Store (rechtsonder menu) → Local Add-ons → Open WebUI Custom
```

Zullen we deze stappen doorlopen? Dan heb je een permanente oplossing.[^9_3][^9_1]

<div align="center">⁂</div>

[^9_1]: https://github.com/home-assistant/supervisor/issues/805

[^9_2]: https://community.home-assistant.io/t/pass-environment-variables-to-addon-containers/766138

[^9_3]: https://developers.home-assistant.io/docs/add-ons/configuration/


---

# open-webui git:(main) \# Bekijk de huidige config

cat config.yaml

# Voeg JWT_EXPIRES_IN toe aan de environment sectie

name: "Open WebUI"
description: "Open WebUI is an extensible, feature-rich, and user-friendly self-hosted AI platform designed to operate entirely offline"
url: [https://github.com/mikastamm/open-webui-homeassistant-addon](https://github.com/mikastamm/open-webui-homeassistant-addon)
version: "v0.7.2"
slug: "openwebui"
panel_icon: mdi:message
init: false

arch:

- aarch64
- amd64
startup: services
webui: "[PROTO:ssl]://[HOST]:[PORT:8080]"
host_network: true
ports:
8080/tcp: 8080
ports_description:
8080/tcp: "Open WebUI Web Interface"
map:
- share
options: {}
schema: {}
image: ghcr.io/mikastamm/open-webui-homeassistant-addon
➜  open-webui git:(main) pwd
/addons/openwebui-custom/open-webui
➜  open-webui git:(main)

Perfect! Je bent al in de juiste directory. Nu gaan we de `config.yaml` aanpassen:

```bash
# Maak een backup
cp config.yaml config.yaml.backup

# Bewerk het bestand en voeg environment sectie toe
cat > config.yaml << 'EOF'
name: "Open WebUI"
description: "Open WebUI is an extensible, feature-rich, and user-friendly self-hosted AI platform designed to operate entirely offline"
url: https://github.com/mikastamm/open-webui-homeassistant-addon
version: "v0.7.2"
slug: "openwebui"
panel_icon: mdi:message
init: false

arch:
  - aarch64
  - amd64
startup: services
webui: "[PROTO:ssl]://[HOST]:[PORT:8080]"
host_network: true
ports:
  8080/tcp: 8080
ports_description:
  8080/tcp: "Open WebUI Web Interface"
map:
  - share
environment:
  JWT_EXPIRES_IN: "300"
options: {}
schema: {}
image: ghcr.io/mikastamm/open-webui-homeassistant-addon
EOF

# Controleer of het gelukt is
cat config.yaml
```

Nu moet je:

1. **Supervisor reloaden**:
```bash
ha supervisor reload
```

2. **In Home Assistant UI**:
    - Ga naar Settings → Add-ons
    - Stop de huidige Open WebUI add-on
    - Zoek in de Add-on Store naar "Open WebUI" (je lokale versie)
    - Installeer de lokale versie
    - Start hem op

De nieuwe versie heeft nu `JWT_EXPIRES_IN=300` ingesteld.[^10_1][^10_2]

<div align="center">⁂</div>

[^10_1]: https://developers.home-assistant.io/docs/add-ons/configuration/

[^10_2]: https://home-assistant-china.github.io/developers/hassio/addon_config/


---

# \# Controleer of het gelukt is

cat config.yaml

name: "Open WebUI"
description: "Open WebUI is an extensible, feature-rich, and user-friendly self-hosted AI platform designed to operate entirely offline"
url: [https://github.com/mikastamm/open-webui-homeassistant-addon](https://github.com/mikastamm/open-webui-homeassistant-addon)
version: "v0.7.2"
slug: "openwebui"
panel_icon: mdi:message
init: false

arch:

- aarch64
- amd64
startup: services
webui: "[PROTO:ssl]://[HOST]:[PORT:8080]"
host_network: true
ports:
8080/tcp: 8080
ports_description:
8080/tcp: "Open WebUI Web Interface"
map:
- share
environment:
JWT_EXPIRES_IN: "300"
options: {}
schema: {}
image: ghcr.io/mikastamm/open-webui-homeassistant-addon

Uitstekend! De `environment` sectie is toegevoegd. Nu de volgende stappen:

```bash
# Reload de supervisor
ha supervisor reload
```

Wacht even tot dit klaar is, en doe dan:

**In Home Assistant UI**:

1. Ga naar **Settings** → **Add-ons**
2. **Stop** de huidige "Open WebUI" add-on
3. Klik rechtsboven op de drie stipjes → **Check for updates** (om de lokale add-on te detecteren)
4. Als je de add-on opnieuw opstart, zou hij nu de nieuwe configuratie moeten gebruiken

**Of**: Herstart de add-on gewoon direct:

```bash
# Herstart de add-on
ha addons restart 4d14bf22_openwebui
```

Na de herstart, controleer of de environment variable is geladen:

```bash
docker exec addon_4d14bf22_openwebui env | grep JWT
```

Als dit `JWT_EXPIRES_IN=300` toont, dan werkt het![^11_1][^11_2]

<div align="center">⁂</div>

[^11_1]: https://home-assistant-china.github.io/developers/hassio/addon_config/

[^11_2]: https://developers.home-assistant.io/docs/add-ons/configuration/


---

# <q>Uitstekend! De environment sectie is toegevoegd. Nu de volgende stappen:

bash\# Reload de supervisor</q> ik zie mijn locale add on niet.

Ik heb wel een eigen repository
[https://github.com/ovenlade/hassio-addons](https://github.com/ovenlade/hassio-addons)

daar kan ik misschien die custom inzetten

Ja, dat is een perfecte oplossing! Dan kun je jouw aangepaste versie via je eigen repository distribueren.

## Voeg de aangepaste add-on toe aan je repository

```bash
# Ga naar je repository directory (of clone het eerst)
cd /tmp
git clone https://github.com/ovenlade/hassio-addons.git
cd hassio-addons

# Kopieer de aangepaste add-on
cp -r /addons/openwebui-custom/open-webui ./open-webui

# Verander de slug om conflict te voorkomen
cd open-webui
```

**Belangrijke aanpassing** - wijzig de `slug` in `config.yaml` zodat hij niet conflicteert met de originele:

```yaml
slug: "openwebui-custom"
```

Dan:

```bash
# Commit en push
git add .
git commit -m "Add custom Open WebUI with JWT_EXPIRES_IN support"
git push
```

**In Home Assistant**:

1. Ga naar **Settings** → **Add-ons** → **Add-on Store** (rechtsonder op de drie stipjes)
2. Je repository staat al in de lijst
3. Klik op **Check for updates** of herlaad de pagina
4. Je zou nu "Open WebUI" (of hoe je het genoemd hebt) moeten zien in je eigen repository sectie
5. Installeer deze versie

Dit is de beste manier - je hebt volledige controle en de wijziging blijft behouden.[^12_1][^12_2]

<div align="center">⁂</div>

[^12_1]: https://home-assistant-china.github.io/developers/hassio/addon_config/

[^12_2]: https://developers.home-assistant.io/docs/add-ons/configuration/


---

# Dockerfile                     config.yaml.backup             icon.png

README.md                      docs-letsencrypt-settings.png  run.sh
➜  open-webui git:(main) ✗ nano config.yaml
➜  open-webui git:(main) ✗ \# Commit en push
git add .
git commit -m "Add custom Open WebUI with JWT_EXPIRES_IN support"
git push

[main 92bb9ad] Add custom Open WebUI with JWT_EXPIRES_IN support
9 files changed, 245 insertions(+)
create mode 100644 open-webui/DOCS.md
create mode 100644 open-webui/Dockerfile
create mode 100644 open-webui/README.md
create mode 100644 open-webui/config.yaml
create mode 100644 open-webui/config.yaml.backup
create mode 100644 open-webui/docs-letsencrypt-settings.png
create mode 100644 open-webui/docs-nginx-1.png
create mode 100644 open-webui/icon.png
create mode 100644 open-webui/run.sh
Username for 'https://github.com': [maartenkeur@pm.me](mailto:maartenkeur@pm.me)
Password for 'https://maartenkeur%40pm.me@github.com':
remote: Invalid username or token. Password authentication is not supported for Git operations.
fatal: Authentication failed for 'https://github.com/ovenlade/hassio-addons.git/'
➜  open-webui git:(main) docker exec addon_4d14bf22_openwebui ls -la /data

Kan ik dit aanzetten? comitten met pwd?

Je hebt een authenticatie probleem. GitHub ondersteunt geen wachtwoord authenticatie meer - je moet een **Personal Access Token** gebruiken.[^13_1]

## Oplossing 1: SSH key gebruiken (aanbevolen)

```bash
# Verander de remote naar SSH
git remote set-url origin git@github.com:ovenlade/hassio-addons.git

# Push opnieuw
git push
```


## Oplossing 2: Personal Access Token

1. Ga naar **GitHub** → **Settings** → **Developer settings** → **Personal access tokens** → **Tokens (classic)**
2. Genereer een nieuwe token met `repo` rechten
3. Gebruik deze als wachtwoord:
```bash
git push
# Username: maartenkeur@pm.me
# Password: [plak je token hier]
```


## Oplossing 3: Token in URL opslaan (tijdelijk)

```bash
git remote set-url origin https://[TOKEN]@github.com/ovenlade/hassio-addons.git
git push
```

**Let op**: Gebruik nooit je echte wachtwoord - GitHub accepteert alleen tokens voor HTTPS authenticatie.

Welke methode wil je gebruiken? SSH is het veiligst en makkelijkst voor de lange termijn.

<div align="center">⁂</div>

[^13_1]: https://github.com/Athozs/hass-environment-variable


---

# ik denk dat ik mijn ssh key moet printen en moet toevoegen aan mijn git account. Klopt dat?

open-webui git:(main) git push
The authenticity of host 'github.com (140.82.121.3)' can't be established.
ED25519 key fingerprint is: SHA256:+DiY3wvvV6TuJJhbpZisF/zLDA0zPMSvHdkr4UvCOqU
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'github.com' (ED25519) to the list of known hosts.
git@github.com: Permission denied (publickey).
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.

Ja precies! Je moet je SSH publieke sleutel toevoegen aan GitHub.

## Stap 1: Bekijk je SSH publieke sleutel

```bash
# Toon je publieke sleutel
cat ~/.ssh/id_rsa.pub
```

Of als je een andere key type hebt:

```bash
cat ~/.ssh/id_ed25519.pub
```

Als er geen key bestaat, maak er dan een:

```bash
ssh-keygen -t ed25519 -C "maartenkeur@pm.me"
# Druk enter voor standaard locatie
# Optioneel: voeg een passphrase toe
```


## Stap 2: Kopieer de publieke sleutel

De output begint met `ssh-rsa` of `ssh-ed25519` - kopieer de **hele regel**.

## Stap 3: Voeg toe aan GitHub

1. Ga naar **GitHub.com** → **Settings** (rechtsboven je profiel)
2. Klik op **SSH and GPG keys** (links in menu)
3. Klik **New SSH key**
4. Geef een titel (bijv. "Home Assistant")
5. Plak je publieke sleutel in het veld
6. Klik **Add SSH key**

## Stap 4: Test en push

```bash
# Test de verbinding
ssh -T git@github.com

# Nu kun je pushen
git push
```

Dit zou nu moeten werken!

---

# maarja dat heb ik geen updates.... :(

Ah, de add-on verschijnt nog niet in je Home Assistant? Dat kan een paar redenen hebben:

## Controleer je repository.json

Zorg dat je een `repository.json` in de **root** van je repository hebt:

```bash
cd /tmp/hassio-addons
cat repository.json
```

Als die er niet is of incompleet is, maak/wijzig hem dan:

```bash
cat > repository.json << 'EOF'
{
  "name": "Ovenlade Add-ons",
  "url": "https://github.com/ovenlade/hassio-addons",
  "maintainer": "Ovenlade"
}
EOF

git add repository.json
git commit -m "Update repository.json"
git push
```


## Force refresh in Home Assistant

1. Ga naar **Settings** → **Add-ons** → **Add-on Store**
2. Klik rechtsbovenin op de **drie puntjes** (⋮)
3. Klik op **Check for updates**
4. Wacht 30-60 seconden
5. Ververs de pagina (F5)

## Of reload via CLI

```bash
ha addons reload
```

Zie je nu je aangepaste Open WebUI add-on verschijnen? Het kan ook zijn dat de slug `openwebui-custom` conflicteert - heb je die aangepast in `config.yaml`?[^15_1][^15_2]

<div align="center">⁂</div>

[^15_1]: https://home-assistant-china.github.io/developers/hassio/addon_config/

[^15_2]: https://developers.home-assistant.io/docs/add-ons/configuration/


---

# nee ik zie hem wel, en werkt ook, maar als open-ui een update heeft, moet ik mijn repository updaten zelf

Ah begrijp ik! Ja klopt, dat is het nadeel van een fork. Je moet handmatig updates van de originele repository binnenhalen.

## Automatisch updates binnenhalen

Je kunt dit simpeler maken door de originele repository als "upstream" toe te voegen:

```bash
cd /tmp/hassio-addons/open-webui

# Voeg originele repo toe als upstream
git remote add upstream https://github.com/mikastamm/open-webui-homeassistant-addon.git

# Haal updates op
git fetch upstream

# Merge updates (let op: jouw JWT_EXPIRES_IN blijft behouden)
git merge upstream/main

# Of rebase (schoner)
git rebase upstream/main

# Push naar jouw repo
git push origin main
```


## Periodiek updaten

Je kunt dit regelmatig doen (bijv. eens per maand):

```bash
cd /tmp/hassio-addons/open-webui
git fetch upstream
git rebase upstream/main
# Los eventuele conflicts op in config.yaml
git push origin main
```

Dan heb je altijd de nieuwste versie van Open WebUI met jouw aangepaste `JWT_EXPIRES_IN` configuratie.[^16_1]

Werkt de session timeout van 5 minuten trouwens zoals je wilde?

<div align="center">⁂</div>

[^16_1]: https://home-assistant-china.github.io/developers/hassio/addon_config/


---

# Ok, ik zie dat updaten heel makkelijk is :)

Mooi! Ja, met die upstream remote is het gewoon `git fetch` en `git merge/rebase` - klaar!

Werkt de `JWT_EXPIRES_IN=300` nu zoals je wilde? Test maar eens of je na 5 minuten inactiviteit wordt uitgelogd.

Je kunt het ook controleren met:

```bash
docker exec addon_4d14bf22_openwebui env | grep JWT
```

Zou nu `JWT_EXPIRES_IN=300` moeten laten zien.[^17_1][^17_2]

<div align="center">⁂</div>

[^17_1]: https://github.com/open-webui/docs/blob/main/docs/features/jwttoken.md

[^17_2]: https://deepwiki.com/open-webui/open-webui/11.4-session-management


---

# Ik kan niet inloggen, waarschijnlijk omdat het verwijderen van de oude add-on niet volledig is uitgevoerd. (restjes verwijderen). Kan jij mij daar mee helpen?

Ja, er blijven waarschijnlijk oude data en configuratiebestanden achter. Laten we die opruimen:

## Verwijder oude add-on data

```bash
# Controleer welke add-on data directories er zijn
ls -la /addon_configs/

# Zoek naar de oude Open WebUI directory (waarschijnlijk met slug)
ls -la /addon_configs/ | grep -i webui

# Verwijder de oude config directory (pas aan naar juiste naam)
rm -rf /addon_configs/4d14bf22_openwebui
# Of
rm -rf /addon_configs/local_openwebui
```


## Verwijder oude volumes/database

```bash
# Controleer of er nog Docker volumes zijn
docker volume ls | grep webui

# Verwijder oude volumes (pas naam aan)
docker volume rm addon_4d14bf22_openwebui
```


## Herstart Supervisor

```bash
ha supervisor restart
```

Na de herstart:

1. Installeer je nieuwe custom Open WebUI add-on opnieuw
2. Start hem op
3. Maak een nieuw admin account aan

Wat is de exacte foutmelding die je krijgt bij inloggen? Dan kan ik specifieker helpen.[^18_1][^18_2]

<div align="center">⁂</div>

[^18_1]: https://github.com/open-webui/open-webui/issues/5866

[^18_2]: https://github.com/open-webui/docs/blob/main/docs/features/jwttoken.md


---

# ➜  homeassistant git:(main) ✗ ls -la /addon_configs/0

ls: /addon_configs/0: No such file or directory
➜  homeassistant git:(main) ✗ ls -la /addon_configs/ | grep -i webui
➜  homeassistant git:(main) ✗ docker volume ls | grep webui
➜  homeassistant git:(main) ✗

API rate limit exceeded

Kijt ik te zien als fout

De foutmelding "API rate limit exceeded" komt niet van login problemen, maar van een **API rate limit** in Open WebUI zelf.[^19_1]

## Controleer de huidige container

```bash
# Bekijk de logs van de nieuwe add-on
docker logs addon_4d14bf22_openwebui

# Of via HA CLI
ha addons logs openwebui-custom
```


## Rate limit configuratie toevoegen

Open WebUI heeft rate limiting ingebouwd. Voeg deze environment variables toe aan je `config.yaml`:

```bash
cd /tmp/hassio-addons/open-webui
nano config.yaml
```

Voeg toe onder de `environment:` sectie:

```yaml
environment:
  JWT_EXPIRES_IN: "300"
  ENABLE_API_KEY_AUTH: "True"
  WEBUI_AUTH: "True"
  ENABLE_RATE_LIMIT: "False"
```

Of verhoog de limiet:

```yaml
  RATE_LIMIT_REQUESTS: "100"
  RATE_LIMIT_WINDOW: "60"
```

Dan:

```bash
git add config.yaml
git commit -m "Disable rate limiting"
git push

# Update in HA
ha addons update openwebui-custom
ha addons restart openwebui-custom
```

Probeer daarna opnieuw in te loggen. Laat de logs ook zien als het nog steeds niet werkt![^19_2][^19_1]

<div align="center">⁂</div>

[^19_1]: https://docs.openwebui.com/getting-started/env-configuration/

[^19_2]: https://github.com/open-webui/open-webui/discussions/18991


---

# |   File "/usr/local/lib/python3.11/site-packages/starlette/_exception_handler.py", line 53, in wrapped_app

    |     raise exc
    |   File "/usr/local/lib/python3.11/site-packages/starlette/_exception_handler.py", line 42, in wrapped_app
    |     await app(scope, receive, sender)
    |   File "/usr/local/lib/python3.11/site-packages/fastapi/middleware/asyncexitstack.py", line 18, in __call__
    |     await self.app(scope, receive, send)
    |   File "/usr/local/lib/python3.11/site-packages/starlette/routing.py", line 716, in __call__
    |     await self.middleware_stack(scope, receive, send)
    |   File "/usr/local/lib/python3.11/site-packages/starlette/routing.py", line 736, in app
    |     await route.handle(scope, receive, send)
    |   File "/usr/local/lib/python3.11/site-packages/starlette/routing.py", line 290, in handle
    |     await self.app(scope, receive, send)
    |   File "/usr/local/lib/python3.11/site-packages/fastapi/routing.py", line 115, in app
    |     await wrap_app_handling_exceptions(app, request)(scope, receive, send)
    |   File "/usr/local/lib/python3.11/site-packages/starlette/_exception_handler.py", line 53, in wrapped_app
    |     raise exc
    |   File "/usr/local/lib/python3.11/site-packages/starlette/_exception_handler.py", line 42, in wrapped_app
    |     await app(scope, receive, sender)
    |   File "/usr/local/lib/python3.11/site-packages/fastapi/routing.py", line 101, in app
    |     response = await f(request)
    |                ^^^^^^^^^^^^^^^^
    |   File "/usr/local/lib/python3.11/site-packages/fastapi/routing.py", line 355, in app
    |     raw_response = await run_endpoint_function(
    |                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    |   File "/usr/local/lib/python3.11/site-packages/fastapi/routing.py", line 243, in run_endpoint_function
    |     return await dependant.call(**values)
    |            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    |   File "/app/backend/open_webui/routers/auths.py", line 650, in signin
    |     expires_delta = parse_duration(request.app.state.config.JWT_EXPIRES_IN)
    |                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    |   File "/app/backend/open_webui/utils/misc.py", line 437, in parse_duration
    |     raise ValueError("Invalid duration string")
    | ValueError: Invalid duration string
    +------------------------------------
    The above exception was the direct cause of the following exception:

Traceback (most recent call last):
File "/usr/local/lib/python3.11/site-packages/uvicorn/protocols/http/httptools_impl.py", line 416, in run_asgi
result = await app(  \# type: ignore[func-returns-value]
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
File "/usr/local/lib/python3.11/site-packages/uvicorn/middleware/proxy_headers.py", line 60, in __call__
return await self.app(scope, receive, send)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
File "/usr/local/lib/python3.11/site-packages/fastapi/applications.py", line 1135, in __call__
await super().__call__(scope, receive, send)
File "/usr/local/lib/python3.11/site-packages/starlette/applications.py", line 107, in __call__
await self.middleware_stack(scope, receive, send)
2026-02-05 21:17:41.546 | INFO     | uvicorn.protocols.http.httptools_impl:send:483 - 192.168.2.164:61102 - "POST /api/v1/auths/signin HTTP/1.1" 429
2026-02-05 21:17:41.549 | INFO     | uvicorn.protocols.http.httptools_impl:send:483 - 192.168.2.164:61104 - "POST /api/v1/auths/signin HTTP/1.1" 429
2026-02-05 21:17:41.552 | INFO     | uvicorn.protocols.http.httptools_impl:send:483 - 192.168.2.164:61103 - "POST /api/v1/auths/signin HTTP/1.1" 429
File "/usr/local/lib/python3.11/site-packages/starlette/middleware/errors.py", line 186, in __call__
raise exc
File "/usr/local/lib/python3.11/site-packages/starlette/middleware/errors.py", line 164, in __call__
await self.app(scope, receive, _send)
File "/usr/local/lib/python3.11/site-packages/starlette/middleware/sessions.py", line 85, in __call__
await self.app(scope, receive, send_wrapper)
File "/usr/local/lib/python3.11/site-packages/starlette/middleware/cors.py", line 93, in __call__
await self.simple_response(scope, receive, send, request_headers=headers)
File "/usr/local/lib/python3.11/site-packages/starlette/middleware/cors.py", line 144, in simple_response
await self.app(scope, receive, send)
File "/usr/local/lib/python3.11/site-packages/starlette/middleware/base.py", line 191, in __call__
with recv_stream, send_stream, collapse_excgroups():
File "/usr/local/lib/python3.11/contextlib.py", line 158, in __exit__
self.gen.throw(typ, value, traceback)
File "/usr/local/lib/python3.11/site-packages/starlette/_utils.py", line 85, in collapse_excgroups
raise exc
File "/usr/local/lib/python3.11/site-packages/starlette/middleware/base.py", line 193, in __call__
response = await self.dispatch_func(request, call_next)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
File "/app/backend/open_webui/main.py", line 1392, in inspect_websocket
return await call_next(request)
^^^^^^^^^^^^^^^^^^^^^^^^
File "/usr/local/lib/python3.11/site-packages/starlette/middleware/base.py", line 168, in call_next
raise app_exc from app_exc.__cause__ or app_exc.__context__
File "/usr/local/lib/python3.11/site-packages/starlette/middleware/base.py", line 144, in coro
await self.app(scope, receive_or_disconnect, send_no_error)
File "/usr/local/lib/python3.11/site-packages/starlette/middleware/base.py", line 191, in __call__
with recv_stream, send_stream, collapse_excgroups():
File "/usr/local/lib/python3.11/contextlib.py", line 158, in __exit__
self.gen.throw(typ, value, traceback)
File "/usr/local/lib/python3.11/site-packages/starlette/_utils.py", line 85, in collapse_excgroups
raise exc
File "/usr/local/lib/python3.11/site-packages/starlette/middleware/base.py", line 193, in __call__
response = await self.dispatch_func(request, call_next)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
File "/app/backend/open_webui/main.py", line 1371, in check_url
response = await call_next(request)
^^^^^^^^^^^^^^^^^^^^^^^^
File "/usr/local/lib/python3.11/site-packages/starlette/middleware/base.py", line 168, in call_next
raise app_exc from app_exc.__cause__ or app_exc.__context__
File "/usr/local/lib/python3.11/site-packages/starlette/middleware/base.py", line 144, in coro
await self.app(scope, receive_or_disconnect, send_no_error)
File "/usr/local/lib/python3.11/site-packages/starlette/middleware/base.py", line 191, in __call__
with recv_stream, send_stream, collapse_excgroups():
File "/usr/local/lib/python3.11/contextlib.py", line 158, in __exit__
self.gen.throw(typ, value, traceback)
File "/usr/local/lib/python3.11/site-packages/starlette/_utils.py", line 85, in collapse_excgroups
raise exc
File "/usr/local/lib/python3.11/site-packages/starlette/middleware/base.py", line 193, in __call__
response = await self.dispatch_func(request, call_next)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
File "/app/backend/open_webui/main.py", line 1357, in commit_session_after_request
response = await call_next(request)
^^^^^^^^^^^^^^^^^^^^^^^^
File "/usr/local/lib/python3.11/site-packages/starlette/middleware/base.py", line 168, in call_next
raise app_exc from app_exc.__cause__ or app_exc.__context__
File "/usr/local/lib/python3.11/site-packages/starlette/middleware/base.py", line 144, in coro
await self.app(scope, receive_or_disconnect, send_no_error)
File "/usr/local/lib/python3.11/site-packages/starlette/middleware/base.py", line 191, in __call__
with recv_stream, send_stream, collapse_excgroups():
File "/usr/local/lib/python3.11/contextlib.py", line 158, in __exit__
self.gen.throw(typ, value, traceback)
File "/usr/local/lib/python3.11/site-packages/starlette/_utils.py", line 85, in collapse_excgroups
raise exc
File "/usr/local/lib/python3.11/site-packages/starlette/middleware/base.py", line 193, in __call__
response = await self.dispatch_func(request, call_next)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
File "/app/backend/open_webui/main.py", line 1348, in dispatch
response = await call_next(request)
^^^^^^^^^^^^^^^^^^^^^^^^
File "/usr/local/lib/python3.11/site-packages/starlette/middleware/base.py", line 168, in call_next
raise app_exc from app_exc.__cause__ or app_exc.__context__
File "/usr/local/lib/python3.11/site-packages/starlette/middleware/base.py", line 144, in coro
await self.app(scope, receive_or_disconnect, send_no_error)
File "/usr/local/lib/python3.11/site-packages/starlette/middleware/base.py", line 191, in __call__
with recv_stream, send_stream, collapse_excgroups():
File "/usr/local/lib/python3.11/contextlib.py", line 158, in __exit__
self.gen.throw(typ, value, traceback)
File "/usr/local/lib/python3.11/site-packages/starlette/_utils.py", line 85, in collapse_excgroups
raise exc
File "/usr/local/lib/python3.11/site-packages/starlette/middleware/base.py", line 193, in __call__
response = await self.dispatch_func(request, call_next)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
File "/app/backend/open_webui/utils/security_headers.py", line 11, in dispatch
response = await call_next(request)
^^^^^^^^^^^^^^^^^^^^^^^^
File "/usr/local/lib/python3.11/site-packages/starlette/middleware/base.py", line 168, in call_next
raise app_exc from app_exc.__cause__ or app_exc.__context__
File "/usr/local/lib/python3.11/site-packages/starlette/middleware/base.py", line 144, in coro
await self.app(scope, receive_or_disconnect, send_no_error)
File "/usr/local/lib/python3.11/site-packages/starlette/middleware/base.py", line 191, in __call__
with recv_stream, send_stream, collapse_excgroups():
File "/usr/local/lib/python3.11/contextlib.py", line 158, in __exit__
self.gen.throw(typ, value, traceback)
File "/usr/local/lib/python3.11/site-packages/starlette/_utils.py", line 85, in collapse_excgroups
raise exc
File "/usr/local/lib/python3.11/site-packages/starlette/middleware/base.py", line 193, in __call__
response = await self.dispatch_func(request, call_next)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
File "/app/backend/open_webui/main.py", line 1304, in dispatch
response = await call_next(request)
^^^^^^^^^^^^^^^^^^^^^^^^
File "/usr/local/lib/python3.11/site-packages/starlette/middleware/base.py", line 168, in call_next
raise app_exc from app_exc.__cause__ or app_exc.__context__
File "/usr/local/lib/python3.11/site-packages/starlette/middleware/base.py", line 144, in coro
await self.app(scope, receive_or_disconnect, send_no_error)
File "/usr/local/lib/python3.11/site-packages/starlette_compress/__init__.py", line 96, in __call__
return await self._gzip(scope, receive, send)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
File "/usr/local/lib/python3.11/site-packages/starlette_compress/_gzip.py", line 110, in __call__
await self.app(scope, receive, wrapper)
File "/usr/local/lib/python3.11/site-packages/starlette/middleware/exceptions.py", line 63, in __call__
await wrap_app_handling_exceptions(self.app, conn)(scope, receive, send)
File "/usr/local/lib/python3.11/site-packages/starlette/_exception_handler.py", line 53, in wrapped_app
raise exc
File "/usr/local/lib/python3.11/site-packages/starlette/_exception_handler.py", line 42, in wrapped_app
await app(scope, receive, sender)
File "/usr/local/lib/python3.11/site-packages/fastapi/middleware/asyncexitstack.py", line 18, in __call__
await self.app(scope, receive, send)
File "/usr/local/lib/python3.11/site-packages/starlette/routing.py", line 716, in __call__
await self.middleware_stack(scope, receive, send)
File "/usr/local/lib/python3.11/site-packages/starlette/routing.py", line 736, in app
await route.handle(scope, receive, send)
File "/usr/local/lib/python3.11/site-packages/starlette/routing.py", line 290, in handle
await self.app(scope, receive, send)
File "/usr/local/lib/python3.11/site-packages/fastapi/routing.py", line 115, in app
await wrap_app_handling_exceptions(app, request)(scope, receive, send)
File "/usr/local/lib/python3.11/site-packages/starlette/_exception_handler.py", line 53, in wrapped_app
raise exc
File "/usr/local/lib/python3.11/site-packages/starlette/_exception_handler.py", line 42, in wrapped_app
await app(scope, receive, sender)
File "/usr/local/lib/python3.11/site-packages/fastapi/routing.py", line 101, in app
response = await f(request)
^^^^^^^^^^^^^^^^
File "/usr/local/lib/python3.11/site-packages/fastapi/routing.py", line 355, in app
raw_response = await run_endpoint_function(
^^^^^^^^^^^^^^^^^^^^^^^^^^^^
File "/usr/local/lib/python3.11/site-packages/fastapi/routing.py", line 243, in run_endpoint_function
return await dependant.call(**values)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
File "/app/backend/open_webui/routers/auths.py", line 650, in signin
expires_delta = parse_duration(request.app.state.config.JWT_EXPIRES_IN)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
File "/app/backend/open_webui/utils/misc.py", line 437, in parse_duration
raise ValueError("Invalid duration string")
ValueError: Invalid duration string
2026-02-05 21:18:37.277 | INFO     | uvicorn.protocols.http.httptools_impl:send:483 - 192.168.2.164:55019 - "GET /_app/version.json HTTP/1.1" 200

Perfect! Nu zie ik het probleem. De foutmelding is duidelijk:

```
ValueError: Invalid duration string
```

Open WebUI verwacht `JWT_EXPIRES_IN` in een **specifiek formaat** zoals `"5m"`, `"1h"`, `"7d"` - niet gewoon `"300"`.[^20_1][^20_2]

## Los het op in config.yaml

```bash
cd /tmp/hassio-addons/open-webui
nano config.yaml
```

Wijzig de `JWT_EXPIRES_IN` waarde naar het correcte formaat:

```yaml
environment:
  JWT_EXPIRES_IN: "5m"
```

Of andere opties:

- `"5m"` = 5 minuten
- `"30m"` = 30 minuten
- `"1h"` = 1 uur
- `"24h"` = 24 uur
- `"7d"` = 7 dagen

Dan:

```bash
git add config.yaml
git commit -m "Fix JWT_EXPIRES_IN format to 5m"
git push

# Update in HA
ha addons restart openwebui-custom
```

Nu zou inloggen moeten werken![^20_2][^20_1]

<div align="center">⁂</div>

[^20_1]: https://github.com/open-webui/docs/blob/main/docs/features/jwttoken.md

[^20_2]: https://deepwiki.com/open-webui/open-webui/11.4-session-management


---

# ➜  open-webui git:(main) ✗ git add config.yaml

git commit -m "Fix JWT_EXPIRES_IN format to 5m"
git push

# Update in HA

ha addons restart openwebui-custom

[main c47b603] Fix JWT_EXPIRES_IN format to 5m
1 file changed, 1 insertion(+), 1 deletion(-)
To github.com:ovenlade/hassio-addons.git
! [rejected]        main -> main (fetch first)
error: failed to push some refs to 'github.com:ovenlade/hassio-addons.git'
hint: Updates were rejected because the remote contains work that you do not
hint: have locally. This is usually caused by another repository pushing to
hint: the same ref. If you want to integrate the remote changes, use
hint: 'git pull' before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.
Error: Addon openwebui-custom does not exist
➜  open-webui git:(main) pwd
/tmp/hassio-addons/open-webui
➜  open-webui git:(main)

Je hebt twee kleine problemen:

## 1. Git conflict oplossen

```bash
# Pull eerst de remote changes
git pull --rebase origin main

# Dan push
git push
```


## 2. Verkeerde slug voor restart

De slug is waarschijnlijk nog `openwebui` in plaats van `openwebui-custom`. Controleer in je config.yaml:

```bash
cat config.yaml | grep slug
```

Gebruik de juiste slug voor restart:

```bash
# Waarschijnlijk een van deze:
ha addons restart openwebui
# Of
ha addons restart 4d14bf22_openwebui

# Of bekijk alle add-ons:
ha addons
```

Zoek in de lijst naar je Open WebUI add-on en gebruik die slug voor restart.[^21_1]

<div align="center">⁂</div>

[^21_1]: https://home-assistant-china.github.io/developers/hassio/addon_config/


---

# ➜  open-webui git:(main) git pull --rebase origin main

remote: Enumerating objects: 7, done.
remote: Counting objects: 100% (7/7), done.
remote: Compressing objects: 100% (4/4), done.
remote: Total 4 (delta 1), reused 0 (delta 0), pack-reused 0 (from 0)
Unpacking objects: 100% (4/4), 1.12 KiB | 575.00 KiB/s, done.
From github.com:ovenlade/hassio-addons

* branch            main       -> FETCH_HEAD
92bb9ad..873ee2f  main       -> origin/main
Successfully rebased and updated refs/heads/main.
➜  open-webui git:(main) git push
Enumerating objects: 7, done.
Counting objects: 100% (7/7), done.
Delta compression using up to 4 threads
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 443 bytes | 443.00 KiB/s, done.
Total 4 (delta 2), reused 0 (delta 0), pack-reused 0 (from 0)
remote: Resolving deltas: 100% (2/2), completed with 2 local objects.
remote: This repository moved. Please use the new location:
remote:   git@github.com:Ovenlade/hassio-addons.git
To github.com:ovenlade/hassio-addons.git
873ee2f..8a241b3  main -> main
➜  open-webui git:(main) cat config.yaml | grep slug
slug: "openwebui-custom"
➜  open-webui git:(main)

Perfect! De push is gelukt. Nu de add-on herstarten:

```bash
# Herstart met de juiste slug
ha addons restart openwebui-custom
```

Als dat niet werkt, bekijk eerst welke add-ons er zijn:

```bash
ha addons | grep -i webui
```

Of via Home Assistant UI:

1. Ga naar **Settings** → **Add-ons**
2. Klik op je **Open WebUI** add-on
3. Klik op **Restart**

Na de herstart zou inloggen moeten werken met de `JWT_EXPIRES_IN: "5m"` configuratie. Test maar eens of je nu kunt inloggen![^22_1]

<div align="center">⁂</div>

[^22_1]: https://github.com/open-webui/docs/blob/main/docs/features/jwttoken.md


---

# weer hetzelfde. Moet ik de add-on niet eerst update in HA?

Ja precies! Je hebt de GitHub repository geüpdatet, maar Home Assistant heeft de **oude versie** nog geïnstalleerd.

```bash
# Forceer Home Assistant om updates te checken
ha addons reload

# Wacht even (10-20 seconden)

# Check of er een update beschikbaar is
ha addons info openwebui-custom

# Update de add-on
ha addons update openwebui-custom

# Herstart
ha addons restart openwebui-custom
```

**Of via UI**:

1. **Settings** → **Add-ons** → **Add-on Store** (rechtsboven drie puntjes)
2. Klik **Check for updates**
3. Ga naar je Open WebUI add-on
4. Klik **Update** (als beschikbaar)
5. Herstart de add-on

De add-on haalt alleen updates binnen als je expliciet update of als de **versie** in `config.yaml` is verhoogd (bijv. van `v0.7.2` naar `v0.7.3`).[^23_1][^23_2]

<div align="center">⁂</div>

[^23_1]: https://home-assistant-china.github.io/developers/hassio/addon_config/

[^23_2]: https://developers.home-assistant.io/docs/add-ons/configuration/


---

# - advanced: false

available: true
build: false
description: Open WebUI is an extensible, feature-rich, and user-friendly self-hosted
AI platform designed to operate entirely offline
detached: false
homeassistant: null
icon: true
logo: false
name: Open WebUI
repository: 95a23923
slug: 95a23923_openwebui-custom
stage: stable
state: started
system_managed: false
update_available: false
url: [https://github.com/mikastamm/open-webui-homeassistant-addon](https://github.com/mikastamm/open-webui-homeassistant-addon)
version: v0.7.2
version_latest: v0.7.2

Ik zie mijn eigen url ook niet... DIe van ovenlade. Dit is de url van de oorspronkelijke add-on

Ah! Home Assistant gebruikt nog steeds de **originele repository URL** uit het Docker image. Het probleem is dat je alleen de `config.yaml` hebt aangepast, maar het image zelf (`ghcr.io/mikastamm/open-webui-homeassistant-addon`) komt nog steeds van mikastamm's registry.[^24_1]

## Oplossing: Verander naar local build

In je `config.yaml`:

```bash
cd /tmp/hassio-addons/open-webui
nano config.yaml
```

**Verwijder** de `image:` regel en voeg `build_from:` toe:

```yaml
name: "Open WebUI Custom"
description: "Open WebUI with custom JWT timeout configuration"
url: https://github.com/ovenlade/hassio-addons
version: "v0.7.3"  # Verhoog versienummer!
slug: "openwebui-custom"
panel_icon: mdi:message
init: false

arch:
  - aarch64
  - amd64

# VERWIJDER DEZE REGEL:
# image: ghcr.io/mikastamm/open-webui-homeassistant-addon

# VOEG DIT TOE:
build_from:
  aarch64: ghcr.io/open-webui/open-webui:main
  amd64: ghcr.io/open-webui/open-webui:main

startup: services
webui: "[PROTO:ssl]://[HOST]:[PORT:8080]"
host_network: true
ports:
  8080/tcp: 8080
ports_description:
  8080/tcp: "Open WebUI Web Interface"
map:
  - share
environment:
  JWT_EXPIRES_IN: "5m"
options: {}
schema: {}
```

Push en update:

```bash
git add config.yaml
git commit -m "Use direct Open WebUI image with custom env"
git push

ha addons reload
ha addons update 95a23923_openwebui-custom
```

Nu bouwt Home Assistant de add-on met jouw environment variables ![^24_2][^24_1]

<div align="center">⁂</div>

[^24_1]: https://home-assistant-china.github.io/developers/hassio/addon_config/

[^24_2]: https://developers.home-assistant.io/docs/add-ons/configuration/


---

# open-webui git:(main) ✗ cat config.yaml

name: "Open WebUI"
description: "Open WebUI is an extensible, feature-rich, and user-friendly self-hosted AI platform designed to operate entirely offline"
url: [https://github.com/mikastamm/open-webui-homeassistant-addon](https://github.com/mikastamm/open-webui-homeassistant-addon)
version: "v0.7.3"
slug: "openwebui-custom"
panel_icon: mdi:message
init: false

# VOEG DIT TOE:

build_from:
aarch64: ghcr.io/open-webui/open-webui:main
amd64: ghcr.io/open-webui/open-webui:main

arch:

- aarch64
- amd64
startup: services
webui: "[PROTO:ssl]://[HOST]:[PORT:8080]"
host_network: true
ports:
8080/tcp: 8080
ports_description:
8080/tcp: "Open WebUI Web Interface"
map:
- share
environment:
JWT_EXPIRES_IN: "5m"
options: {}
schema: {}
➜  open-webui git:(main) ✗ pwd
/tmp/hassio-addons/open-webui
➜  open-webui git:(main) ✗

Zo goed?

Bijna! Verwijder alleen de comment regel (`# VOEG DIT TOE:`), die hoort niet in de YAML:

```bash
nano config.yaml
```

Verwijder de regel `# VOEG DIT TOE:` en zorg dat het er zo uitziet:

```yaml
name: "Open WebUI"
description: "Open WebUI is an extensible, feature-rich, and user-friendly self-hosted AI platform designed to operate entirely offline"
url: https://github.com/mikastamm/open-webui-homeassistant-addon
version: "v0.7.3"
slug: "openwebui-custom"
panel_icon: mdi:message
init: false

build_from:
  aarch64: ghcr.io/open-webui/open-webui:main
  amd64: ghcr.io/open-webui/open-webui:main

arch:
  - aarch64
  - amd64
startup: services
webui: "[PROTO:ssl]://[HOST]:[PORT:8080]"
host_network: true
ports:
  8080/tcp: 8080
ports_description:
  8080/tcp: "Open WebUI Web Interface"
map:
  - share
environment:
  JWT_EXPIRES_IN: "5m"
options: {}
schema: {}
```

Dan pushen:

```bash
git add config.yaml
git commit -m "Remove comment from config.yaml"
git push

ha addons reload
ha addons update 95a23923_openwebui-custom
```

Nu is het goed![^25_1]

<div align="center">⁂</div>

[^25_1]: https://home-assistant-china.github.io/developers/hassio/addon_config/


---

# ➜  open-webui git:(main) ✗ git add config.yaml

git commit -m "Remove comment from config.yaml"
git push

ha addons reload
ha addons update 95a23923_openwebui-custom

[main 15cd765] Remove comment from config.yaml
1 file changed, 5 insertions(+), 2 deletions(-)
Enumerating objects: 7, done.
Counting objects: 100% (7/7), done.
Delta compression using up to 4 threads
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 488 bytes | 488.00 KiB/s, done.
Total 4 (delta 2), reused 0 (delta 0), pack-reused 0 (from 0)
remote: Resolving deltas: 100% (2/2), completed with 2 local objects.
remote: This repository moved. Please use the new location:
remote:   git@github.com:Ovenlade/hassio-addons.git
To github.com:ovenlade/hassio-addons.git
8a241b3..15cd765  main -> main
addons:

- advanced: false
available: true
build: false
description: Expose Home Assistant folders with SMB/CIFS
detached: false
homeassistant: null
icon: true
logo: true
name: Samba share
repository: core
slug: core_samba
stage: stable
state: started
system_managed: false
update_available: false
url: [https://github.com/home-assistant/addons/tree/master/samba](https://github.com/home-assistant/addons/tree/master/samba)
version: 12.5.4
version_latest: 12.5.4
- advanced: false
available: true
build: false
description: An open-source database built on PostgreSQL for analyzing time-series
data with the power and convenience of SQL
detached: false
homeassistant: null
icon: true
logo: true
name: TimescaleDB
repository: 77b2833f
slug: 77b2833f_timescaledb
stage: stable
state: started
system_managed: false
update_available: false
url: [https://github.com/expaso/hassos-addon-timescaledb](https://github.com/expaso/hassos-addon-timescaledb)
version: 5.4.2
version_latest: 5.4.2
- advanced: false
available: true
build: false
description: An Open Source MQTT broker
detached: false
homeassistant: null
icon: true
logo: true
name: Mosquitto broker
repository: core
slug: core_mosquitto
stage: stable
state: started
system_managed: false
update_available: false
url: [https://github.com/home-assistant/addons/tree/master/mosquitto](https://github.com/home-assistant/addons/tree/master/mosquitto)
version: 6.5.2
version_latest: 6.5.2
- advanced: false
available: true
build: false
description: Simple browser-based file editor for Home Assistant
detached: false
homeassistant: 0.91.1
icon: true
logo: true
name: File editor
repository: core
slug: core_configurator
stage: stable
state: started
system_managed: false
update_available: false
url: [https://github.com/home-assistant/addons/tree/master/configurator](https://github.com/home-assistant/addons/tree/master/configurator)
version: 5.8.0
version_latest: 5.8.0
- advanced: false
available: true
build: false
description: A supercharged SSH \& Web Terminal access to your Home Assistant instance
detached: false
homeassistant: 0.92.0b2
icon: true
logo: true
name: Advanced SSH \& Web Terminal
repository: a0d7b954
slug: a0d7b954_ssh
stage: stable
state: started
system_managed: false
update_available: true
url: [https://github.com/hassio-addons/app-ssh](https://github.com/hassio-addons/app-ssh)
version: 23.0.0
version_latest: 23.0.1
- advanced: false
available: true
build: false
description: A SQL database server
detached: false
homeassistant: null
icon: true
logo: true
name: MariaDB
repository: core
slug: core_mariadb
stage: stable
state: started
system_managed: false
update_available: false
url: [https://github.com/home-assistant/addons/tree/master/mariadb](https://github.com/home-assistant/addons/tree/master/mariadb)
version: 2.7.2
version_latest: 2.7.2
- advanced: false
available: true
build: false
description: Automatically manage backups between Home Assistant and Google Drive
detached: false
homeassistant: null
icon: true
logo: true
name: Home Assistant Google Drive Backup
repository: cebe7a76
slug: cebe7a76_hassio_google_drive_backup
stage: stable
state: started
system_managed: false
update_available: false
url: [https://github.com/sabeechen/hassio-google-drive-backup](https://github.com/sabeechen/hassio-google-drive-backup)
version: 0.112.1
version_latest: 0.112.1
- advanced: true
available: true
build: false
description: Allow logging in remotely to Home Assistant using SSH
detached: false
homeassistant: null
icon: true
logo: true
name: Terminal \& SSH
repository: core
slug: core_ssh
stage: stable
state: started
system_managed: false
update_available: true
url: [https://github.com/home-assistant/addons/tree/master/ssh](https://github.com/home-assistant/addons/tree/master/ssh)
version: 9.22.0
version_latest: 10.0.0
- advanced: false
available: true
build: false
description: Shutdown Windows machines remotely
detached: false
homeassistant: null
icon: true
logo: true
name: RPC Shutdown
repository: core
slug: core_rpc_shutdown
stage: stable
state: started
system_managed: false
update_available: false
url: [https://github.com/home-assistant/addons/tree/master/rpc_shutdown](https://github.com/home-assistant/addons/tree/master/rpc_shutdown)
version: "2.5"
version_latest: "2.5"
- advanced: false
available: true
build: false
description: Used for reading the smart meter DSMR P1 port (https://dsmr-reader.readthedocs.io)
detached: false
homeassistant: null
icon: true
logo: true
name: DSMR Reader
repository: 0826754b
slug: 0826754b_dsmr_reader
stage: stable
state: started
system_managed: false
update_available: false
url: [https://github.com/sanderdw/hassio-addons](https://github.com/sanderdw/hassio-addons)
version: 1.12.2
version_latest: 1.12.2
- advanced: false
available: true
build: false
description: Manage your Docker environment with ease
detached: false
homeassistant: null
icon: true
logo: true
name: Portainer
repository: db21ed7f
slug: db21ed7f_portainer
stage: stable
state: unknown
system_managed: false
update_available: false
url: [https://github.com/alexbelgium/hassio-addons](https://github.com/alexbelgium/hassio-addons)
version: 2.38.0
version_latest: 2.38.0
- advanced: false
available: true
build: false
description: A cross-platform system monitoring tool
detached: false
homeassistant: 0.92.0b2
icon: true
logo: true
name: Glances
repository: a0d7b954
slug: a0d7b954_glances
stage: stable
state: started
system_managed: false
update_available: false
url: [https://github.com/hassio-addons/addon-glances](https://github.com/hassio-addons/addon-glances)
version: 0.21.1
version_latest: 0.21.1
- advanced: false
available: true
build: false
description: Nextcloud for Homeassistant
detached: false
homeassistant: null
icon: true
logo: true
name: Nextcloud
repository: db21ed7f
slug: db21ed7f_nextcloud_ocr
stage: stable
state: started
system_managed: false
update_available: false
url: [https://github.com/alexbelgium/hassio-addons/tree/master/nextcloud](https://github.com/alexbelgium/hassio-addons/tree/master/nextcloud)
version: 32.0.5-2
version_latest: 32.0.5-2
- advanced: false
available: true
build: false
description: Docker container for Firefox
detached: false
homeassistant: null
icon: true
logo: true
name: Firefox
repository: 49e24ccc
slug: 49e24ccc_firefox
stage: stable
state: started
system_managed: false
update_available: false
url: [https://github.com/mincka/ha-addons/tree/main/firefox](https://github.com/mincka/ha-addons/tree/main/firefox)
version: 1.9.1
version_latest: 1.9.1
- advanced: false
available: true
build: false
description: Collabora Online office suite
detached: false
homeassistant: null
icon: true
logo: true
name: Collabora
repository: db21ed7f
slug: db21ed7f_collabora
stage: stable
state: started
system_managed: false
update_available: false
url: [https://github.com/alexbelgium/hassio-addons](https://github.com/alexbelgium/hassio-addons)
version: 25.4.8.1
version_latest: 25.4.8.1
- advanced: false
available: true
build: false
description: Open WebUI is an extensible, feature-rich, and user-friendly self-hosted
AI platform designed to operate entirely offline
detached: false
homeassistant: null
icon: true
logo: false
name: Open WebUI
repository: 95a23923
slug: 95a23923_openwebui-custom
stage: stable
state: started
system_managed: false
update_available: false
url: [https://github.com/mikastamm/open-webui-homeassistant-addon](https://github.com/mikastamm/open-webui-homeassistant-addon)
version: v0.7.2
version_latest: v0.7.2
Processing... Done.

Error: No update available for add-on 95a23923_openwebui-custom
➜  open-webui git:(main)

De add-on ziet nog steeds `v0.7.2` terwijl jij `v0.7.3` hebt gepusht. Home Assistant heeft de update nog niet opgehaald uit je repository.

Probeer dit:

```bash
# Forceer volledige repository refresh
ha supervisor reload

# Wacht 10-15 seconden

# Check opnieuw
ha addons info 95a23923_openwebui-custom
```

Als het nog steeds `v0.7.2` is, dan moet je de add-on **verwijderen en opnieuw installeren**:

```bash
# Uninstall huidige add-on
ha addons uninstall 95a23923_openwebui-custom

# Supervisor reload
ha supervisor reload

# Wacht even, dan via UI:
```

**Via UI**:

1. **Settings** → **Add-ons** → **Add-on Store**
2. Scroll naar je **Ovenlade Add-ons** repository sectie
3. Installeer **Open WebUI** opnieuw (nu met versie v0.7.3)

Dan wordt de nieuwe configuratie met `JWT_EXPIRES_IN: "5m"` en `build_from` geladen.[^26_1][^26_2]

<div align="center">⁂</div>

[^26_1]: https://home-assistant-china.github.io/developers/hassio/addon_config/

[^26_2]: https://developers.home-assistant.io/docs/add-ons/configuration/


---

# vanuit de interface geprobeerd te updaten.

Error updating Open WebUI: An unknown error occurred while trying to build the image for addon 95a23923_openwebui-custom. Check supervisor logs for details (check with 'ha supervisor logs')

➜  open-webui git:(main) ha supervisor logs
2026-02-05 21:35:04.045 WARNING (MainThread) [supervisor.store.git] There is already a task in progress
2026-02-05 21:35:04.373 WARNING (MainThread) [supervisor.store.git] There is already a task in progress
2026-02-05 21:35:04.373 INFO (MainThread) [supervisor.store.git] Update add-on /data/addons/git/3ce0ef5e repository from [https://github.com/mdvorak/ha-addon-jellyfin](https://github.com/mdvorak/ha-addon-jellyfin)
2026-02-05 21:35:04.374 WARNING (MainThread) [supervisor.store.git] There is already a task in progress
2026-02-05 21:35:04.375 WARNING (MainThread) [supervisor.store.git] There is already a task in progress
2026-02-05 21:35:04.379 WARNING (MainThread) [supervisor.store.git] There is already a task in progress
2026-02-05 21:35:04.381 WARNING (MainThread) [supervisor.store.git] There is already a task in progress
2026-02-05 21:35:04.383 INFO (MainThread) [supervisor.store.git] Update add-on /data/addons/git/c80c7555 repository from [https://github.com/einschmidt/hassio-addons](https://github.com/einschmidt/hassio-addons)
2026-02-05 21:35:04.384 WARNING (MainThread) [supervisor.store.git] There is already a task in progress
2026-02-05 21:35:04.386 WARNING (MainThread) [supervisor.store.git] There is already a task in progress
2026-02-05 21:35:04.387 WARNING (MainThread) [supervisor.store.git] There is already a task in progress
2026-02-05 21:35:04.388 WARNING (MainThread) [supervisor.store.git] There is already a task in progress
2026-02-05 21:35:04.389 WARNING (MainThread) [supervisor.store.git] There is already a task in progress
2026-02-05 21:35:04.390 WARNING (MainThread) [supervisor.store.git] There is already a task in progress
2026-02-05 21:35:04.397 WARNING (MainThread) [supervisor.store.git] There is already a task in progress
2026-02-05 21:35:04.398 WARNING (MainThread) [supervisor.store.git] There is already a task in progress
2026-02-05 21:35:10.793 INFO (MainThread) [supervisor.docker.addon] Updating image ghcr.io/mikastamm/open-webui-homeassistant-addon:v0.7.2 to 95a23923/amd64-addon-openwebui-custom:v0.7.3
2026-02-05 21:35:10.801 INFO (MainThread) [supervisor.docker.addon] Starting build for ghcr.io/mikastamm/open-webui-homeassistant-addon:v0.7.3
2026-02-05 21:35:10.809 INFO (SyncWorker_5) [supervisor.docker.manager] Running command '['docker', 'buildx', 'build', '.', '--tag', '95a23923/amd64-addon-openwebui-custom:v0.7.3', '--file', 'Dockerfile', '--platform', 'linux/amd64', '--pull', '--label', 'io.hass.version=v0.7.3', '--label', 'io.hass.arch=amd64', '--label', 'io.hass.type=addon', '--label', 'io.hass.name=Open WebUI', '--label', 'io.hass.description=Open WebUI is an extensible, feature-rich, and user-friendly self-hosted AI platform designed to operate entirely offline', '--label', 'io.hass.url=https://github.com/mikastamm/open-webui-homeassistant-addon', '--build-arg', 'BUILD_FROM=ghcr.io/home-assistant/amd64-base:latest', '--build-arg', 'BUILD_VERSION=v0.7.3', '--build-arg', 'BUILD_ARCH=amd64']' on docker.io/library/docker:29.1.3-cli
2026-02-05 21:35:18.596 ERROR (MainThread) [supervisor.docker.addon] Can't build ghcr.io/mikastamm/open-webui-homeassistant-addon:v0.7.3: Docker build failed for 95a23923/amd64-addon-openwebui-custom:v0.7.3 (exit code 1). Build output:
\#0 building with "default" instance using docker driver

\#1 [internal] load build definition from Dockerfile
\#1 transferring dockerfile: 551B done
\#1 DONE 0.0s

\#2 [internal] load metadata for ghcr.io/open-webui/open-webui:v0.7.2
\#2 DONE 1.1s

\#3 [internal] load .dockerignore
\#3 transferring context: 2B done
\#3 DONE 0.0s

\#4 [internal] load build context
\#4 transferring context: 2B done
\#4 DONE 0.0s

\#5 [2/3] COPY open-webui/run.sh .
\#5 ERROR: failed to calculate checksum of ref e999fda9-d895-42cb-9bc6-488f56382c22::uy2ntw3o8fhsb3tqe7zd2huut: "/open-webui/run.sh": not found

\#6 [1/3] FROM ghcr.io/open-webui/open-webui:v0.7.2@sha256:16d9a3615b45f14a0c89f7ad7a3bf151f923ed32c2e68f9204eb17d1ce40774b
\#6 resolve ghcr.io/open-webui/open-webui:v0.7.2@sha256:16d9a3615b45f14a0c89f7ad7a3bf151f923ed32c2e68f9204eb17d1ce40774b done
\#6 sha256:b3767bb4c3c9af3d63b935b4bf8ba9b1edddf2213526167b7d0f5edef7aebc12 19.73kB / 19.73kB done
\#6 sha256:16d9a3615b45f14a0c89f7ad7a3bf151f923ed32c2e68f9204eb17d1ce40774b 1.61kB / 1.61kB done
\#6 sha256:c0db68c3c5c3fb55f2ce6757029db9c94385c0efffdda7844796b1534e53e1de 3.71kB / 3.71kB done
\#6 DONE 0.1s
------
> [2/3] COPY open-webui/run.sh .:
------
Dockerfile:19
--------------------
17 |     ENV DATA_DIR=/data
18 |
19 | >>> COPY open-webui/run.sh .
20 |     RUN chmod a+x run.sh


| 21 |
| :-- |

ERROR: failed to build: failed to solve: failed to compute cache key: failed to calculate checksum of ref e999fda9-d895-42cb-9bc6-488f56382c22::uy2ntw3o8fhsb3tqe7zd2huut: "/open-webui/run.sh": not found

2026-02-05 21:35:18.596 ERROR (MainThread) [supervisor.addons.addon] Could not build image for addon 95a23923_openwebui-custom: Can't build ghcr.io/mikastamm/open-webui-homeassistant-addon:v0.7.3: Docker build failed for 95a23923/amd64-addon-openwebui-custom:v0.7.3 (exit code 1). Build output:
\#0 building with "default" instance using docker driver

\#1 [internal] load build definition from Dockerfile
\#1 transferring dockerfile: 551B done
\#1 DONE 0.0s

\#2 [internal] load metadata for ghcr.io/open-webui/open-webui:v0.7.2
\#2 DONE 1.1s

\#3 [internal] load .dockerignore
\#3 transferring context: 2B done
\#3 DONE 0.0s

\#4 [internal] load build context
\#4 transferring context: 2B done
\#4 DONE 0.0s

\#5 [2/3] COPY open-webui/run.sh .
\#5 ERROR: failed to calculate checksum of ref e999fda9-d895-42cb-9bc6-488f56382c22::uy2ntw3o8fhsb3tqe7zd2huut: "/open-webui/run.sh": not found

\#6 [1/3] FROM ghcr.io/open-webui/open-webui:v0.7.2@sha256:16d9a3615b45f14a0c89f7ad7a3bf151f923ed32c2e68f9204eb17d1ce40774b
\#6 resolve ghcr.io/open-webui/open-webui:v0.7.2@sha256:16d9a3615b45f14a0c89f7ad7a3bf151f923ed32c2e68f9204eb17d1ce40774b done
\#6 sha256:b3767bb4c3c9af3d63b935b4bf8ba9b1edddf2213526167b7d0f5edef7aebc12 19.73kB / 19.73kB done
\#6 sha256:16d9a3615b45f14a0c89f7ad7a3bf151f923ed32c2e68f9204eb17d1ce40774b 1.61kB / 1.61kB done
\#6 sha256:c0db68c3c5c3fb55f2ce6757029db9c94385c0efffdda7844796b1534e53e1de 3.71kB / 3.71kB done
\#6 DONE 0.1s
------
> [2/3] COPY open-webui/run.sh .:
------
Dockerfile:19
--------------------
17 |     ENV DATA_DIR=/data
18 |
19 | >>> COPY open-webui/run.sh .
20 |     RUN chmod a+x run.sh


| 21 |
| :-- |

ERROR: failed to build: failed to solve: failed to compute cache key: failed to calculate checksum of ref e999fda9-d895-42cb-9bc6-488f56382c22::uy2ntw3o8fhsb3tqe7zd2huut: "/open-webui/run.sh": not found

2026-02-05 21:36:28.339 INFO (MainThread) [supervisor.api.middleware.security] /supervisor/logs access from a0d7b954_ssh
➜  open-webui git:(main)

Ah! De Dockerfile probeert te bouwen maar kan `run.sh` niet vinden. Het probleem is dat je `build_from` gebruikt, maar de Dockerfile verwacht bestanden die niet in je repository staan.

## Twee oplossingen:

### Optie 1: Gebruik gewoon het pre-built image (simpelst)

Verwijder `build_from` en gebruik gewoon het image met environment variables:

```bash
cd /tmp/hassio-addons/open-webui
nano config.yaml
```

Wijzig naar:

```yaml
name: "Open WebUI"
description: "Open WebUI is an extensible, feature-rich, and user-friendly self-hosted AI platform designed to operate entirely offline"
url: https://github.com/ovenlade/hassio-addons
version: "v0.7.4"
slug: "openwebui-custom"
panel_icon: mdi:message
init: false

arch:
  - aarch64
  - amd64

image: ghcr.io/open-webui/open-webui:latest

startup: services
webui: "[PROTO:ssl]://[HOST]:[PORT:8080]"
host_network: true
ports:
  8080/tcp: 8080
ports_description:
  8080/tcp: "Open WebUI Web Interface"
map:
  - share
environment:
  JWT_EXPIRES_IN: "5m"
  DATA_DIR: "/data"
options: {}
schema: {}
```

Push dit:

```bash
git add config.yaml
git commit -m "Use pre-built image instead of building"
git push

ha supervisor reload
ha addons uninstall 95a23923_openwebui-custom
ha supervisor reload
```

Dan via UI opnieuw installeren. Dit zou moeten werken![^27_1][^27_2]

<div align="center">⁂</div>

[^27_1]: https://home-assistant-china.github.io/developers/hassio/addon_config/

[^27_2]: https://developers.home-assistant.io/docs/add-ons/configuration/


---

# in mijn interface zie ik heb bij overnlade niet meer staan...

➜  open-webui git:(main) ✗ git add config.yaml
git commit -m "Use pre-built image instead of building"
git push

ha supervisor reload
ha addons uninstall 95a23923_openwebui-custom
ha supervisor reload

[main 092ea14] Use pre-built image instead of building
1 file changed, 6 insertions(+), 6 deletions(-)
Enumerating objects: 7, done.
Counting objects: 100% (7/7), done.
Delta compression using up to 4 threads
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 556 bytes | 556.00 KiB/s, done.
Total 4 (delta 2), reused 0 (delta 0), pack-reused 0 (from 0)
remote: Resolving deltas: 100% (2/2), completed with 2 local objects.
remote: This repository moved. Please use the new location:
remote:   git@github.com:Ovenlade/hassio-addons.git
To github.com:ovenlade/hassio-addons.git
15cd765..092ea14  main -> main
Command completed successfully.
Command completed successfully.
Command completed successfully.
➜  open-webui git:(main) ha supervisor reload
Command completed successfully.
➜  open-webui git:(main)

De add-on is geüninstalleerd en supervisor is gereload. Nu moet je wachten tot de repositories zijn bijgewerkt en dan opnieuw installeren:

```bash
# Wacht 15-20 seconden voor repositories update

# Check of je repository zichtbaar is
ha addons | grep -i "ovenlade\|webui"

# Of check alle repositories
ha store repositories
```

Als je de add-on niet ziet in de interface, probeer dan:

**Via UI**:

1. **Settings** → **Add-ons** → **Add-on Store**
2. Klik rechtsboven op de **drie puntjes** (⋮)
3. Klik **Repositories**
4. Controleer of `https://github.com/Ovenlade/hassio-addons` in de lijst staat
5. Zo niet, voeg hem toe
6. Klik **Check for updates**
7. Ververs de pagina (F5)

Dan zou je onder **Ovenlade Add-ons** (of hoe je repository genoemd is) de "Open WebUI" moeten zien staan om te installeren.[^28_1]

Zie je de repository wel maar de add-on niet?

<div align="center">⁂</div>

[^28_1]: https://home-assistant-china.github.io/developers/hassio/addon_config/


---

# ik zie mijn andere add-on wel bij overnlade maar niet webui

Dan is er een probleem met de repository structuur. Controleer of de `open-webui` directory correct staat in de root van je repository:

```bash
# Check de structuur
cd /tmp/hassio-addons
ls -la

# Zou moeten zijn:
# repository.json
# open-webui/
#   config.yaml
#   Dockerfile
#   run.sh
#   etc.
```

Als `open-webui` in een verkeerde plek staat, verplaats hem:

```bash
cd /tmp/hassio-addons

# Check waar open-webui staat
find . -name "config.yaml" -path "*/open-webui/*"

# Als hij niet direct in de root staat, verplaats hem
# Bijvoorbeeld als hij in een submap zit
```

Ook moet je een **`repository.json`** hebben in de root. Check deze:

```bash
cat repository.json
```

Zou er ongeveer zo uit moeten zien:

```json
{
  "name": "Ovenlade Add-ons",
  "url": "https://github.com/Ovenlade/hassio-addons",
  "maintainer": "Ovenlade"
}
```

Push eventuele wijzigingen:

```bash
git add .
git commit -m "Fix repository structure"
git push

ha supervisor reload
```

Laat me de output zien van `ls -la` in de repository root.[^29_1]

<div align="center">⁂</div>

[^29_1]: https://home-assistant-china.github.io/developers/hassio/addon_config/


---

# open-webui git:(main) cd /tmp/hassio-addons

ls -la
total 24
drwxr-xr-x    5 root     root          4096 Feb  5 07:52 .
drwxrwxrwt    1 root     root          4096 Feb  5 21:20 ..
drwxr-xr-x    7 root     root          4096 Feb  5 21:38 .git
drwxr-xr-x    2 root     root          4096 Feb  5 07:52 mediatracker
drwxr-xr-x    2 root     root          4096 Feb  5 21:22 open-webui
-rw-r--r--    1 root     root           363 Feb  5 07:52 repository.yaml
➜  hassio-addons git:(main)

Aha! Je hebt `repository.yaml` maar Home Assistant verwacht `repository.json`!

```bash
cd /tmp/hassio-addons

# Maak repository.json
cat > repository.json << 'EOF'
{
  "name": "Ovenlade Add-ons",
  "url": "https://github.com/Ovenlade/hassio-addons",
  "maintainer": "Ovenlade"
}
EOF

# Push
git add repository.json
git commit -m "Add repository.json"
git push

ha supervisor reload
```

Wacht 10-15 seconden en check dan in de Add-on Store. Nu zou je Open WebUI moeten zien onder Ovenlade Add-ons ![^30_1][^30_2]

<div align="center">⁂</div>

[^30_1]: https://home-assistant-china.github.io/developers/hassio/addon_config/

[^30_2]: https://developers.home-assistant.io/docs/add-ons/configuration/


---

# hoe bedoel je. Wat moet ik doen?

Voer deze commando's uit:

```bash
cd /tmp/hassio-addons

cat > repository.json << 'EOF'
{
  "name": "Ovenlade Add-ons",
  "url": "https://github.com/Ovenlade/hassio-addons",
  "maintainer": "Ovenlade"
}
EOF

git add repository.json
git commit -m "Add repository.json"
git push

ha supervisor reload
```

Dit maakt een nieuw bestand `repository.json` aan (je hebt nu alleen `repository.yaml`, maar Home Assistant heeft `repository.json` nodig).[^31_1][^31_2]

Na `ha supervisor reload` wacht je 15 seconden en dan zou Open WebUI zichtbaar moeten zijn in de Add-on Store onder "Ovenlade Add-ons".

<div align="center">⁂</div>

[^31_1]: https://home-assistant-china.github.io/developers/hassio/addon_config/

[^31_2]: https://developers.home-assistant.io/docs/add-ons/configuration/


---

# nog steeds niet

Controleer of de `config.yaml` in de juiste plek staat en correct is:

```bash
cd /tmp/hassio-addons/open-webui

# Check of config.yaml bestaat en geldig is
cat config.yaml

# Check ook of er errors zijn in de config
cat config.yaml | head -20
```

En check de supervisor logs voor errors:

```bash
ha supervisor logs | grep -i "webui\|ovenlade\|95a23923"
```

Laat me de output zien, dan kunnen we zien wat er mis gaat.[^32_1][^32_2]

<div align="center">⁂</div>

[^32_1]: https://home-assistant-china.github.io/developers/hassio/addon_config/

[^32_2]: https://developers.home-assistant.io/docs/add-ons/configuration/


---

# mmand completed successfully.

➜  hassio-addons git:(main) cd /tmp/hassio-addons/open-webui

# Check of config.yaml bestaat en geldig is

cat config.yaml
name: "Open WebUI"
description: "Open WebUI is an extensible, feature-rich, and user-friendly self-hosted AI platform designed to operate entirely offline"
url: [https://github.com/ovenlade/hassio-addons](https://github.com/ovenlade/hassio-addons)
version: "v0.7.4"
slug: "openwebui-custom"
panel_icon: mdi:message
init: false

arch:

- aarch64
- amd64

image: ghcr.io/open-webui/open-webui:latest

startup: services
webui: "[PROTO:ssl]://[HOST]:[PORT:8080]"
host_network: true
ports:
8080/tcp: 8080
ports_description:
8080/tcp: "Open WebUI Web Interface"
map:

- share
environment:
JWT_EXPIRES_IN: "5m"
DATA_DIR: "/data"
options: {}
schema: {}
➜  open-webui git:(main)

De config ziet er goed uit. Check nu de supervisor logs:

```bash
ha supervisor logs | tail -50
```

Of specifieker:

```bash
ha supervisor logs | grep -i "95a23923\|ovenlade\|openwebui"
```

En probeer ook handmatig de repository te refreshen:

```bash
# Check welke repositories bekend zijn
ha store repositories

# Reload nogmaals
ha supervisor reload

# Wacht 20 seconden en check addons
ha addons | grep -i webui
```

Als dat niet werkt, probeer de repository opnieuw toe te voegen via de UI:

1. **Settings** → **Add-ons** → **Add-on Store** → **⋮** (rechtsboven) → **Repositories**
2. Verwijder `https://github.com/Ovenlade/hassio-addons` (als hij er staat)
3. Voeg hem opnieuw toe: `https://github.com/Ovenlade/hassio-addons`
4. Klik **Add** en wacht

Laat de output van de logs zien.[^33_1]

<div align="center">⁂</div>

[^33_1]: https://home-assistant-china.github.io/developers/hassio/addon_config/


---

# open-webui git:(main) ha supervisor logs | tail -50

2026-02-05 21:45:55.007 INFO (MainThread) [supervisor.store.git] Update add-on /data/addons/git/567c2022 repository from [https://github.com/davidramosweb/hassio-addons](https://github.com/davidramosweb/hassio-addons)
2026-02-05 21:45:55.016 INFO (MainThread) [supervisor.store.git] Update add-on /data/addons/git/32b8266a repository from [https://github.com/erik73/hassio-addons](https://github.com/erik73/hassio-addons)
2026-02-05 21:45:55.017 INFO (MainThread) [supervisor.store.git] Update add-on /data/addons/git/49e24ccc repository from [https://github.com/mincka/ha-addons](https://github.com/mincka/ha-addons)
2026-02-05 21:45:55.020 INFO (MainThread) [supervisor.store.git] Update add-on /data/addons/git/2effc9b9 repository from [https://github.com/jdeath/homeassistant-addons](https://github.com/jdeath/homeassistant-addons)
2026-02-05 21:45:55.021 INFO (MainThread) [supervisor.store.git] Update add-on /data/addons/git/4d14bf22 repository from [https://github.com/mikastamm/open-webui-homeassistant-addon](https://github.com/mikastamm/open-webui-homeassistant-addon)

➜  open-webui git:(main) ha supervisor logs | grep -i "95a23923\\|ovenlade\\|openwebui"
2026-02-05 21:40:08.482 INFO (MainThread) [supervisor.store.git] Update add-on /data/addons/git/95a23923 repository from [https://github.com/ovenlade/hassio-addons](https://github.com/ovenlade/hassio-addons)
2026-02-05 21:40:34.571 INFO (MainThread) [supervisor.store.git] Update add-on /data/addons/git/95a23923 repository from [https://github.com/ovenlade/hassio-addons](https://github.com/ovenlade/hassio-addons)
2026-02-05 21:45:55.005 INFO (MainThread) [supervisor.store.git] Update add-on /data/addons/git/95a23923 repository from [https://github.com/ovenlade/hassio-addons](https://github.com/ovenlade/hassio-addons)
2026-02-05 21:45:57.716 WARNING (SyncWorker_1) [supervisor.store.data] Can't read /data/addons/git/95a23923/open-webui/config.yaml: does not match regular expression ^([a-z0-9][a-z0-9.\\-]*(:[0-9]+)?/)*?([a-z0-9{][a-z0-9.\\-_{}]*/)*?([a-z0-9{][a-z0-9.\\-_{}]*)\$ for dictionary value @ data['image']. Got 'ghcr.io/open-webui/open-webui:latest'
2026-02-05 21:45:58.530 INFO (MainThread) [supervisor.store.git] Update add-on /data/addons/git/95a23923 repository from [https://github.com/ovenlade/hassio-addons](https://github.com/ovenlade/hassio-addons)
➜  open-webui git:(main)

2026-02-05 21:45:55.028 INFO (MainThread) [supervisor.store.git] Update add-on /data/addons/git/0826754b repository from [https://github.com/sanderdw/hassio-addons](https://github.com/sanderdw/hassio-addons)
2026-02-05 21:45:55.383 INFO (MainThread) [supervisor.store.git] Update add-on /data/addons/git/c80c7555 repository from [https://github.com/einschmidt/hassio-addons](https://github.com/einschmidt/hassio-addons)
2026-02-05 21:45:55.408 INFO (MainThread) [supervisor.store.git] Update add-on /data/addons/git/db21ed7f repository from [https://github.com/alexbelgium/hassio-addons](https://github.com/alexbelgium/hassio-addons)
2026-02-05 21:45:57.716 WARNING (SyncWorker_1) [supervisor.store.data] Can't read /data/addons/git/95a23923/open-webui/config.yaml: does not match regular expression ^([a-z0-9][a-z0-9.\\-]*(:[0-9]+)?/)*?([a-z0-9{][a-z0-9.\\-_{}]*/)*?([a-z0-9{][a-z0-9.\\-_{}]*)\$ for dictionary value @ data['image']. Got 'ghcr.io/open-webui/open-webui:latest'
2026-02-05 21:45:57.778 WARNING (SyncWorker_7) [supervisor.addons.validate] Add-on 'pgAdmin4' uses deprecated 'codenotary' field in config. This field is no longer used and will be ignored. Please report this to the maintainer.
2026-02-05 21:45:57.782 WARNING (SyncWorker_7) [supervisor.addons.validate] Add-on 'TimescaleDB' uses deprecated 'codenotary' field in config. This field is no longer used and will be ignored. Please report this to the maintainer.
2026-02-05 21:45:57.974 WARNING (SyncWorker_2) [supervisor.addons.validate] Add-on 'Nginx Proxy Manager' uses deprecated 'codenotary' field in config. This field is no longer used and will be ignored. Please report this to the maintainer.
2026-02-05 21:45:57.978 WARNING (SyncWorker_2) [supervisor.addons.validate] Add-on 'Glances' uses deprecated 'codenotary' field in config. This field is no longer used and will be ignored. Please report this to the maintainer.
2026-02-05 21:45:57.986 WARNING (SyncWorker_2) [supervisor.addons.validate] Add-on 'MQTT IO' uses deprecated 'codenotary' field in config. This field is no longer used and will be ignored. Please report this to the maintainer.
2026-02-05 21:45:57.999 WARNING (SyncWorker_2) [supervisor.addons.validate] Add-on 'Overseerr' uses deprecated 'codenotary' field in config. This field is no longer used and will be ignored. Please report this to the maintainer.
2026-02-05 21:45:58.020 WARNING (SyncWorker_2) [supervisor.addons.validate] Add-on 'Log Viewer' uses deprecated 'codenotary' field in config. This field is no longer used and will be ignored. Please report this to the maintainer.
2026-02-05 21:45:58.022 WARNING (SyncWorker_2) [supervisor.addons.validate] Add-on 'Grocy' uses deprecated 'codenotary' field in config. This field is no longer used and will be ignored. Please report this to the maintainer.
2026-02-05 21:45:58.025 WARNING (SyncWorker_2) [supervisor.addons.validate] Add-on 'Folding@home' uses deprecated 'codenotary' field in config. This field is no longer used and will be ignored. Please report this to the maintainer.
2026-02-05 21:45:58.032 WARNING (SyncWorker_2) [supervisor.addons.validate] Add-on 'Traccar' uses deprecated 'codenotary' field in config. This field is no longer used and will be ignored. Please report this to the maintainer.
2026-02-05 21:45:58.043 WARNING (SyncWorker_2) [supervisor.addons.validate] Add-on 'InfluxDB' uses deprecated 'codenotary' field in config. This field is no longer used and will be ignored. Please report this to the maintainer.
2026-02-05 21:45:58.052 WARNING (SyncWorker_7) [supervisor.addons.validate] Add-on config 'devices' use a deprecated format, the new format uses a list of paths only. Please report this to the maintainer of Hassio Hostapd
2026-02-05 21:45:58.052 WARNING (SyncWorker_7) [supervisor.addons.validate] Add-on have full device access, and selective device access in the configuration. Please report this to the maintainer of Hassio Hostapd
2026-02-05 21:45:58.054 WARNING (SyncWorker_7) [supervisor.addons.validate] Add-on config 'devices' use a deprecated format, the new format uses a list of paths only. Please report this to the maintainer of Hassio Hostapd
2026-02-05 21:45:58.054 WARNING (SyncWorker_7) [supervisor.addons.validate] Add-on have full device access, and selective device access in the configuration. Please report this to the maintainer of Hassio Hostapd
2026-02-05 21:45:58.298 INFO (MainThread) [supervisor.store] Loading add-ons from store: 308 all - 0 new - 0 remove
2026-02-05 21:45:58.516 INFO (MainThread) [supervisor.store.git] Update add-on /data/addons/git/d5369777 repository from [https://github.com/music-assistant/home-assistant-addon](https://github.com/music-assistant/home-assistant-addon)
2026-02-05 21:45:58.516 INFO (MainThread) [supervisor.store.git] Update add-on /data/addons/git/a0d7b954 repository from [https://github.com/hassio-addons/repository](https://github.com/hassio-addons/repository)
2026-02-05 21:45:58.516 INFO (MainThread) [supervisor.store.git] Update add-on /data/addons/core repository from [https://github.com/home-assistant/addons](https://github.com/home-assistant/addons)
2026-02-05 21:45:58.517 INFO (MainThread) [supervisor.store.git] Update add-on /data/addons/git/5c53de3b repository from [https://github.com/esphome/home-assistant-addon](https://github.com/esphome/home-assistant-addon)
2026-02-05 21:45:58.530 INFO (MainThread) [supervisor.store.git] Update add-on /data/addons/git/95a23923 repository from [https://github.com/ovenlade/hassio-addons](https://github.com/ovenlade/hassio-addons)
2026-02-05 21:45:58.534 INFO (MainThread) [supervisor.store.git] Update add-on /data/addons/git/32b8266a repository from [https://github.com/erik73/hassio-addons](https://github.com/erik73/hassio-addons)
2026-02-05 21:45:58.535 INFO (MainThread) [supervisor.store.git] Update add-on /data/addons/git/77b2833f repository from [https://github.com/Expaso/hassos-addons](https://github.com/Expaso/hassos-addons)
2026-02-05 21:45:58.543 INFO (MainThread) [supervisor.store.git] Update add-on /data/addons/git/3ce0ef5e repository from [https://github.com/mdvorak/ha-addon-jellyfin](https://github.com/mdvorak/ha-addon-jellyfin)
2026-02-05 21:45:58.543 INFO (MainThread) [supervisor.store.git] Update add-on /data/addons/git/c80c7555 repository from [https://github.com/einschmidt/hassio-addons](https://github.com/einschmidt/hassio-addons)
2026-02-05 21:45:58.544 INFO (MainThread) [supervisor.store.git] Update add-on /data/addons/git/567c2022 repository from [https://github.com/davidramosweb/hassio-addons](https://github.com/davidramosweb/hassio-addons)
2026-02-05 21:45:58.551 INFO (MainThread) [supervisor.store.git] Update add-on /data/addons/git/243ffc37 repository from [https://github.com/Poeschl/Hassio-Addons](https://github.com/Poeschl/Hassio-Addons)
2026-02-05 21:45:58.552 INFO (MainThread) [supervisor.store.git] Update add-on /data/addons/git/9074a9fa repository from [https://github.com/brenner-tobias/ha-addons](https://github.com/brenner-tobias/ha-addons)
2026-02-05 21:45:58.553 INFO (MainThread) [supervisor.store.git] Update add-on /data/addons/git/db21ed7f repository from [https://github.com/alexbelgium/hassio-addons](https://github.com/alexbelgium/hassio-addons)
2026-02-05 21:45:58.558 INFO (MainThread) [supervisor.store.git] Update add-on /data/addons/git/94cfad5a repository from [https://github.com/home-assistant/addons-example](https://github.com/home-assistant/addons-example)
2026-02-05 21:45:58.562 INFO (MainThread) [supervisor.store.git] Update add-on /data/addons/git/0826754b repository from [https://github.com/sanderdw/hassio-addons](https://github.com/sanderdw/hassio-addons)
2026-02-05 21:45:58.564 INFO (MainThread) [supervisor.store.git] Update add-on /data/addons/git/2effc9b9 repository from [https://github.com/jdeath/homeassistant-addons](https://github.com/jdeath/homeassistant-addons)
2026-02-05 21:45:58.565 INFO (MainThread) [supervisor.store.git] Update add-on /data/addons/git/49e24ccc repository from [https://github.com/mincka/ha-addons](https://github.com/mincka/ha-addons)
2026-02-05 21:45:58.566 INFO (MainThread) [supervisor.store.git] Update add-on /data/addons/git/cebe7a76 repository from [https://github.com/sabeechen/hassio-google-drive-backup](https://github.com/sabeechen/hassio-google-drive-backup)
2026-02-05 21:45:58.572 INFO (MainThread) [supervisor.store.git] Update add-on /data/addons/git/4d14bf22 repository from [https://github.com/mikastamm/open-webui-homeassistant-addon](https://github.com/mikastamm/open-webui-homeassistant-addon)
2026-02-05 21:46:24.168 INFO (MainThread) [supervisor.api.middleware.security] /addons access from a0d7b954_ssh
2026-02-05 21:46:29.522 INFO (MainThread) [supervisor.api.middleware.security] /supervisor/reload access from a0d7b954_ssh
2026-02-05 21:46:29.522 INFO (MainThread) [supervisor.updater] Fetching update data from [https://version.home-assistant.io/stable.json](https://version.home-assistant.io/stable.json)
2026-02-05 21:46:29.523 INFO (MainThread) [supervisor.resolution.evaluate] Starting system evaluation with state running
2026-02-05 21:46:29.585 INFO (MainThread) [supervisor.resolution.evaluate] System evaluation complete
2026-02-05 21:47:34.507 INFO (MainThread) [supervisor.api.middleware.security] /supervisor/logs access from a0d7b954_ssh
➜  open-webui git:(main)

Daar is het probleem!

```
Can't read /data/addons/git/95a23923/open-webui/config.yaml: does not match regular expression ^([a-z0-9][a-z0-9.\\-]*(:[0-9]+)?/)*?([a-z0-9{][a-z0-9.\\-_{}]*/)*?([a-z0-9{][a-z0-9.\\-_{}]*)$ for dictionary value @ data['image']. Got 'ghcr.io/open-webui/open-webui:latest'
```

Home Assistant accepteert niet `ghcr.io/open-webui/open-webui:latest` als image naam. Je moet een **specifieke versie** gebruiken in plaats van `:latest`:

```bash
cd /tmp/hassio-addons/open-webui
nano config.yaml
```

Wijzig de image regel naar:

```yaml
image: ghcr.io/open-webui/open-webui:v0.7.2
```

Of gebruik gewoon de originele mikastamm image (die werkte wel):

```yaml
image: ghcr.io/mikastamm/open-webui-homeassistant-addon:v0.7.2
```

Push:

```bash
git add config.yaml
git commit -m "Fix image tag to specific version"
git push

ha supervisor reload
```

Nu zou de add-on zichtbaar moeten worden![^34_1][^34_2]

<div align="center">⁂</div>

[^34_1]: https://home-assistant-china.github.io/developers/hassio/addon_config/

[^34_2]: https://developers.home-assistant.io/docs/add-ons/configuration/


---

# ➜  open-webui git:(main) ✗ git add config.yaml

git commit -m "Fix image tag to specific version"
git push

ha supervisor reload

[main 7977972] Fix image tag to specific version
1 file changed, 1 insertion(+), 1 deletion(-)
Enumerating objects: 7, done.
Counting objects: 100% (7/7), done.
Delta compression using up to 4 threads
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 372 bytes | 372.00 KiB/s, done.
Total 4 (delta 3), reused 0 (delta 0), pack-reused 0 (from 0)
remote: Resolving deltas: 100% (3/3), completed with 3 local objects.
remote: This repository moved. Please use the new location:
remote:   git@github.com:Ovenlade/hassio-addons.git
To github.com:ovenlade/hassio-addons.git
b180afd..7977972  main -> main
Command completed successfully.
➜  open-webui git:(main) ha supervisor logs | grep -i "95a23923\\|ovenlade\\|openwebui"
2026-02-05 21:45:57.716 WARNING (SyncWorker_1) [supervisor.store.data] Can't read /data/addons/git/95a23923/open-webui/config.yaml: does not match regular expression ^([a-z0-9][a-z0-9.\\-]*(:[0-9]+)?/)*?([a-z0-9{][a-z0-9.\\-_{}]*/)*?([a-z0-9{][a-z0-9.\\-_{}]*)\$ for dictionary value @ data['image']. Got 'ghcr.io/open-webui/open-webui:latest'
2026-02-05 21:45:58.530 INFO (MainThread) [supervisor.store.git] Update add-on /data/addons/git/95a23923 repository from [https://github.com/ovenlade/hassio-addons](https://github.com/ovenlade/hassio-addons)
2026-02-05 21:50:29.932 INFO (MainThread) [supervisor.store.git] Update add-on /data/addons/git/95a23923 repository from [https://github.com/ovenlade/hassio-addons](https://github.com/ovenlade/hassio-addons)
2026-02-05 21:50:32.594 WARNING (SyncWorker_6) [supervisor.store.data] Can't read /data/addons/git/95a23923/open-webui/config.yaml: does not match regular expression ^([a-z0-9][a-z0-9.\\-]*(:[0-9]+)?/)*?([a-z0-9{][a-z0-9.\\-_{}]*/)*?([a-z0-9{][a-z0-9.\\-_{}]*)\$ for dictionary value @ data['image']. Got 'ghcr.io/mikastamm/open-webui-homeassistant-addon:latest'
➜  open-webui git:(main) cat config.yaml
name: "Open WebUI"
description: "Open WebUI is an extensible, feature-rich, and user-friendly self-hosted AI platform designed to operate entirely offline"
url: [https://github.com/ovenlade/hassio-addons](https://github.com/ovenlade/hassio-addons)
version: "v0.7.4"
slug: "openwebui-custom"
panel_icon: mdi:message
init: false

arch:

- aarch64
- amd64

image: ghcr.io/mikastamm/open-webui-homeassistant-addon:v0.7.2

startup: services
webui: "[PROTO:ssl]://[HOST]:[PORT:8080]"
host_network: true
ports:
8080/tcp: 8080
ports_description:
8080/tcp: "Open WebUI Web Interface"
map:

- share
environment:
JWT_EXPIRES_IN: "5m"
DATA_DIR: "/data"
options: {}
schema: {}
➜  open-webui git:(main)

Vreemd, de log zegt nog steeds `:latest` terwijl je config `v0.7.2` heeft. De cache is nog niet vernieuwd. Probeer dit:

```bash
# Forceer een volledige cache clear
ha supervisor restart

# Dit duurt ~30 seconden, wacht tot het klaar is
```

Of als je niet wilt wachten op een supervisor restart, verander de **versie** in config.yaml (Home Assistant kijkt naar versienummer voor updates):

```bash
cd /tmp/hassio-addons/open-webui
nano config.yaml
```

Verander:

```yaml
version: "v0.7.5"
```

Push:

```bash
git add config.yaml
git commit -m "Bump version to force reload"
git push

ha supervisor reload
```

Wacht 20 seconden en check:

```bash
ha addons | grep -i webui
```

Nu zou hij zichtbaar moeten zijn.[^35_1]

<div align="center">⁂</div>

[^35_1]: https://home-assistant-china.github.io/developers/hassio/addon_config/


---

# open-webui git:(main) \# Forceer een volledige cache clear

ha supervisor restart

# Dit duurt ~30 seconden, wacht tot het klaar is

Command completed successfully.
➜  open-webui git:(main) ha supervisor logs | grep -i "95a23923\\|ovenlade\\|openwebui"
Error: Get "http://supervisor/supervisor/logs": dial tcp 172.30.32.2:80: connect: connection refused
➜  open-webui git:(main) ha supervisor logs | grep -i "95a23923\\|ovenlade\\|openwebui"
Error: Get "http://supervisor/supervisor/logs": dial tcp 172.30.32.2:80: connect: connection refused
➜  open-webui git:(main) ha supervisor logs | grep -i "95a23923\\|ovenlade\\|openwebui"
Error: Get "http://supervisor/supervisor/logs": dial tcp 172.30.32.2:80: connect: connection refused
➜  open-webui git:(main) ha supervisor logs | grep -i "95a23923\\|ovenlade\\|openwebui"
Error: Get "http://supervisor/supervisor/logs": dial tcp 172.30.32.2:80: connect: connection refused
➜  open-webui git:(main) ha supervisor logs | grep -i "95a23923\\|ovenlade\\|openwebui"
Error: Get "http://supervisor/supervisor/logs": dial tcp 172.30.32.2:80: connect: connection refused
➜  open-webui git:(main) ha supervisor logs | grep -i "95a23923\\|ovenlade\\|openwebui"
➜  open-webui git:(main) ha supervisor logs | grep -i "95a23923\\|ovenlade\\|openwebui"
➜  open-webui git:(main) ha supervisor logs | grep -i "95a23923\\|ovenlade\\|openwebui"
➜  open-webui git:(main) ha supervisor logs | grep -i "95a23923\\|ovenlade\\|openwebui"
➜  open-webui git:(main) ha supervisor logs | grep -i "95a23923\\|ovenlade\\|openwebui"
➜  open-webui git:(main) ha supervisor logs | grep -i "95a23923\\|ovenlade\\|openwebui"
2026-02-05 21:53:18.923 INFO (MainThread) [supervisor.store.git] Loading add-on /data/addons/git/95a23923 repository
2026-02-05 21:53:19.871 WARNING (SyncWorker_3) [supervisor.store.data] Can't read /data/addons/git/95a23923/open-webui/config.yaml: does not match regular expression ^([a-z0-9][a-z0-9.\\-]*(:[0-9]+)?/)*?([a-z0-9{][a-z0-9.\\-_{}]*/)*?([a-z0-9{][a-z0-9.\\-_{}]*)\$ for dictionary value @ data['image']. Got 'ghcr.io/mikastamm/open-webui-homeassistant-addon:latest'
➜  open-webui git:(main)

De supervisor is herstart en laadt nog steeds een oude gecachte versie. Het probleem is dat Home Assistant de oude versie lokaal heeft gecached in `/data/addons/git/95a23923/`.

Verwijder de lokale cache:

```bash
# Verwijder de lokale cache van je repository
rm -rf /data/addons/git/95a23923

# Reload supervisor
ha supervisor reload
```

Wacht 20 seconden en check:

```bash
ha supervisor logs | grep -i "95a23923"
```

Dit zou de repository opnieuw moeten clonen vanaf GitHub met de juiste `v0.7.2` image tag.[^36_1]

<div align="center">⁂</div>

[^36_1]: https://home-assistant-china.github.io/developers/hassio/addon_config/


---

# ➜  open-webui git:(main) \# Verwijder de lokale cache van je repository

rm -rf /data/addons/git/95a23923

# Reload supervisor

ha supervisor reload

Command completed successfully.
➜  open-webui git:(main) ha supervisor logs | grep -i "95a23923\\|ovenlade\\|openwebui"
2026-02-05 21:53:19.871 WARNING (SyncWorker_3) [supervisor.store.data] Can't read /data/addons/git/95a23923/open-webui/config.yaml: does not match regular expression ^([a-z0-9][a-z0-9.\\-]*(:[0-9]+)?/)*?([a-z0-9{][a-z0-9.\\-_{}]*/)*?([a-z0-9{][a-z0-9.\\-_{}]*)\$ for dictionary value @ data['image']. Got 'ghcr.io/mikastamm/open-webui-homeassistant-addon:latest'
➜  open-webui git:(main) ha supervisor logs | grep -i "95a23923\\|ovenlade\\|openwebui"
2026-02-05 21:53:19.871 WARNING (SyncWorker_3) [supervisor.store.data] Can't read /data/addons/git/95a23923/open-webui/config.yaml: does not match regular expression ^([a-z0-9][a-z0-9.\\-]*(:[0-9]+)?/)*?([a-z0-9{][a-z0-9.\\-_{}]*/)*?([a-z0-9{][a-z0-9.\\-_{}]*)\$ for dictionary value @ data['image']. Got 'ghcr.io/mikastamm/open-webui-homeassistant-addon:latest'
➜  open-webui git:(main) ha supervisor logs | grep -i "95a23923\\|ovenlade\\|openwebui"
2026-02-05 21:53:19.871 WARNING (SyncWorker_3) [supervisor.store.data] Can't read /data/addons/git/95a23923/open-webui/config.yaml: does not match regular expression ^([a-z0-9][a-z0-9.\\-]*(:[0-9]+)?/)*?([a-z0-9{][a-z0-9.\\-_{}]*/)*?([a-z0-9{][a-z0-9.\\-_{}]*)\$ for dictionary value @ data['image']. Got 'ghcr.io/mikastamm/open-webui-homeassistant-addon:latest'
➜  open-webui git:(main)

Het blijft de oude versie lezen. Laten we checken wat er daadwerkelijk in de lokale cache staat:

```bash
# Check of de directory opnieuw is aangemaakt
ls -la /data/addons/git/

# Check wat er in de lokale config staat
cat /data/addons/git/95a23923/open-webui/config.yaml 2>/dev/null || echo "Niet gevonden"
```

Als de directory er nog is met de oude config, dan heeft supervisor hem al gecloned voordat we hem verwijderden. Probeer dit:

```bash
# Stop alle store updates
ha supervisor options --store-auto-update=false

# Verwijder opnieuw
rm -rf /data/addons/git/95a23923

# Forceer repository reload met delay
sleep 5
ha supervisor reload

# Wacht 15 seconden
sleep 15

# Check
cat /data/addons/git/95a23923/open-webui/config.yaml | grep image
```

Laat me zien wat de output is.[^37_1]

<div align="center">⁂</div>

[^37_1]: https://home-assistant-china.github.io/developers/hassio/addon_config/


---

# ➜  open-webui git:(main) \# Check of de directory opnieuw is aangemaakt

ls -la /data/addons/git/

# Check wat er in de lokale config staat

cat /data/addons/git/95a23923/open-webui/config.yaml 2>/dev/null || echo "Niet gevonden"

ls: /data/addons/git/: No such file or directory
Niet gevonden
➜  open-webui git:(main)

Ah! De hele `/data/addons/git/` directory is weg. Dat betekent dat je repository **helemaal niet meer geladen is**. Reload de supervisor opnieuw:

```bash
ha supervisor reload

# Wacht 30 seconden
sleep 30

# Check of de directory nu bestaat
ls -la /data/addons/git/

# Check of je repository er is
ls -la /data/addons/git/ | grep 95a23923

# Check de config
cat /data/addons/git/95a23923/open-webui/config.yaml | grep image
```

Als de directories nu worden aangemaakt, zou de juiste versie van GitHub moeten worden opgehaald.[^38_1]

<div align="center">⁂</div>

[^38_1]: https://home-assistant-china.github.io/developers/hassio/addon_config/


---

# afgelopen half uur was heel slecht. Geen vooruitgang. Jammer ook dat je de setting in het begin verkeerd hebt gegokt en nu niet een simpele aanpassing kan doen. Er treed enrom verval op in het resultaat

Answer skipped.

---

# ➜  open-webui git:(main) ha supervisor reload

Command completed successfully.
➜  open-webui git:(main) ls -la /data/addons/git/

# Check of je repository er is

ls -la /data/addons/git/ | grep 95a23923

# Check de config

cat /data/addons/git/95a23923/open-webui/config.yaml | grep image
ls: /data/addons/git/: No such file or directory
ls: /data/addons/git/: No such file or directory
cat: can't open '/data/addons/git/95a23923/open-webui/config.yaml': No such file or directory
➜  open-webui git:(main) ls -la /data/addons/git/

# Check of je repository er is

ls -la /data/addons/git/ | grep 95a23923

# Check de config

cat /data/addons/git/95a23923/open-webui/config.yaml | grep image
ls: /data/addons/git/: No such file or directory
ls: /data/addons/git/: No such file or directory
cat: can't open '/data/addons/git/95a23923/open-webui/config.yaml': No such file or directory
➜  open-webui git:(main) ls -la /data/addons/git/

# Check of je repository er is

ls -la /data/addons/git/ | grep 95a23923

# Check de config

cat /data/addons/git/95a23923/open-webui/config.yaml | grep image
ls: /data/addons/git/: No such file or directory
ls: /data/addons/git/: No such file or directory
cat: can't open '/data/addons/git/95a23923/open-webui/config.yaml': No such file or directory
➜  open-webui git:(main)

De repositories worden niet meer geladen. Laten we via de UI het probleem oplossen:

**Via Home Assistant UI:**

1. Ga naar **Settings** → **Add-ons** → **Add-on Store**
2. Klik rechtsboven op **⋮** (drie puntjes)
3. Klik **Repositories**
4. **Verwijder** `https://github.com/Ovenlade/hassio-addons`
5. Klik **Close**
6. Klik opnieuw op **⋮** → **Repositories**
7. **Voeg toe**: `https://github.com/Ovenlade/hassio-addons`
8. Klik **Add**
9. Wacht 30 seconden
10. Ververs de pagina

Dan check:

```bash
ls -la /data/addons/git/ | grep 95a23923
cat /data/addons/git/95a23923/open-webui/config.yaml | grep image
```

De UI trigger moet de repositories opnieuw laden.[^40_1]

<div align="center">⁂</div>

[^40_1]: https://home-assistant-china.github.io/developers/hassio/addon_config/


---

# ik zie weer alleen mediatracker, niet webuit

Check of de `open-webui` directory daadwerkelijk in je GitHub repository staat:

```bash
# Check je lokale repository structuur
cd /tmp/hassio-addons
ls -la

# Check of open-webui folder er is
ls -la open-webui/

# Check de config
cat open-webui/config.yaml | head -20
```

En check ook via GitHub zelf of de `open-webui` folder zichtbaar is op: https://github.com/Ovenlade/hassio-addons

Als de folder er wel is, maar Home Assistant hem niet ziet, kan het zijn dat de `config.yaml` nog steeds een validatiefout heeft. Laat me de volledige huidige `config.yaml` zien.[^41_1]

<div align="center">⁂</div>

[^41_1]: https://home-assistant-china.github.io/developers/hassio/addon_config/


---

# ➜  open-webui git:(main) \# Check je lokale repository structuur

cd /tmp/hassio-addons
ls -la

# Check of open-webui folder er is

ls -la open-webui/

# Check de config

cat open-webui/config.yaml | head -20

total 28
drwxr-xr-x    5 root     root          4096 Feb  5 21:45 .
drwxrwxrwt    1 root     root          4096 Feb  5 21:45 ..
drwxr-xr-x    7 root     root          4096 Feb  5 21:51 .git
drwxr-xr-x    2 root     root          4096 Feb  5 07:52 mediatracker
drwxr-xr-x    2 root     root          4096 Feb  5 21:22 open-webui
-rw-r--r--    1 root     root           115 Feb  5 21:45 repository.json
-rw-r--r--    1 root     root           363 Feb  5 07:52 repository.yaml
total 104
drwxr-xr-x    2 root     root          4096 Feb  5 21:22 .
drwxr-xr-x    5 root     root          4096 Feb  5 21:45 ..
-rw-r--r--    1 root     root          4465 Feb  5 07:52 DOCS.md
-rw-r--r--    1 root     root           512 Feb  5 07:52 Dockerfile
-rw-r--r--    1 root     root           155 Feb  5 21:22 README.md
-rw-r--r--    1 root     root           631 Feb  5 21:51 config.yaml
-rw-r--r--    1 root     root           577 Feb  5 07:52 config.yaml.backup
-rw-r--r--    1 root     root         12510 Feb  5 07:52 docs-letsencrypt-settings.png
-rw-r--r--    1 root     root         41299 Feb  5 07:52 docs-nginx-1.png
-rw-r--r--    1 root     root          9356 Feb  5 07:52 icon.png
-rw-r--r--    1 root     root             0 Feb  5 07:52 run.sh
name: "Open WebUI"
description: "Open WebUI is an extensible, feature-rich, and user-friendly self-hosted AI platform designed to operate entirely offline"
url: [https://github.com/ovenlade/hassio-addons](https://github.com/ovenlade/hassio-addons)
version: "v0.7.4"
slug: "openwebui-custom"
panel_icon: mdi:message
init: false

arch:

- aarch64
- amd64

image: ghcr.io/mikastamm/open-webui-homeassistant-addon:v0.7.2

startup: services
webui: "[PROTO:ssl]://[HOST]:[PORT:8080]"
host_network: true
ports:
8080/tcp: 8080
ports_description:
➜  hassio-addons git:(main)

De structuur ziet er goed uit. Laten we checken wat Home Assistant precies ziet in de logs:

```bash
ha supervisor logs | tail -100 | grep -i "95a23923\|ovenlade"
```

En check ook of `/data/addons/git/` nu bestaat na het toevoegen van de repository via UI:

```bash
ls -la /data/addons/git/
```

Als de directory er is, check dan wat er precies staat:

```bash
ls -la /data/addons/git/95a23923/
cat /data/addons/git/95a23923/open-webui/config.yaml 2>/dev/null | grep image
```

Laat me de output zien, dan kunnen we zien waar het fout gaat.[^42_1]

<div align="center">⁂</div>

[^42_1]: https://home-assistant-china.github.io/developers/hassio/addon_config/


---

# ➜  hassio-addons git:(main) ha supervisor logs | tail -100 | grep -i "95a23923\\|ovenlade"

2026-02-05 21:58:05.639 INFO (MainThread) [supervisor.store.git] Removing custom add-on repository [https://github.com/ovenlade/hassio-addons](https://github.com/ovenlade/hassio-addons)
2026-02-05 21:58:29.563 INFO (MainThread) [supervisor.store.git] Cloning add-on /data/addons/git/95a23923 repository from [https://github.com/Ovenlade/hassio-addons](https://github.com/Ovenlade/hassio-addons)
2026-02-05 21:58:30.210 WARNING (SyncWorker_4) [supervisor.store.data] Can't read /data/addons/git/95a23923/open-webui/config.yaml: does not match regular expression ^([a-z0-9][a-z0-9.\\-]*(:[0-9]+)?/)*?([a-z0-9{][a-z0-9.\\-_{}]*/)*?([a-z0-9{][a-z0-9.\\-_{}]*)\$ for dictionary value @ data['image']. Got 'ghcr.io/mikastamm/open-webui-homeassistant-addon:v0.7.2'
➜  hassio-addons git:(main)

Ah! Het probleem is duidelijk - Home Assistant accepteert de image naam `ghcr.io/mikastamm/open-webui-homeassistant-addon:v0.7.2` niet vanwege de regex validatie.

De image naam is **te lang** of bevat karakters die niet voldoen aan de regex. Laten we het probleem oplossen door terug te gaan naar een simpelere aanpak - gebruik gewoon environment variables **zonder** een custom image:

```bash
cd /tmp/hassio-addons/open-webui
nano config.yaml
```

Verwijder de `image:` regel helemaal en laat Home Assistant de standaard base image gebruiken. Of gebruik een kortere image naam. Probeer dit:

```yaml
name: "Open WebUI Custom"
description: "Open WebUI with custom JWT timeout"
url: https://github.com/ovenlade/hassio-addons
version: "v0.7.5"
slug: "openwebui-custom"
panel_icon: mdi:message
init: false

arch:
  - aarch64
  - amd64

startup: services
webui: "[PROTO:ssl]://[HOST]:[PORT:8080]"
ports:
  8080/tcp: 8080
map:
  - share
environment:
  JWT_EXPIRES_IN: "5m"
options: {}
schema: {}
```

En kopieer de `Dockerfile` en `run.sh` van de originele mikastamm repository, maar pas `run.sh` aan om de environment variable door te geven.

Wil je dat ik dit uitleg, of stoppen we hier?[^43_1][^43_2]

<div align="center">⁂</div>

[^43_1]: https://home-assistant-china.github.io/developers/hassio/addon_config/

[^43_2]: https://developers.home-assistant.io/docs/add-ons/configuration/


---

# ja niet stoppen met uitleggen aub. Ik heb de config WEER aangepast. wat moet ik nu doen?

Oké, nu gaan we het goed aanpakken. Je hebt de `image:` regel verwijderd, dus nu moet Home Assistant de add-on **builden** met de Dockerfile die er al in zit.

Maar we moeten de `run.sh` aanpassen zodat de environment variable daadwerkelijk wordt gebruikt:

```bash
cd /tmp/hassio-addons/open-webui

# Bekijk de huidige run.sh
cat run.sh
```

Als `run.sh` leeg is of niet klopt, moeten we hem aanmaken. Eerst checken:

```bash
# Check of Dockerfile er is en wat erin staat
cat Dockerfile
```

Laat me de output van beide bestanden zien, dan kan ik je precies vertellen wat je moet aanpassen om `JWT_EXPIRES_IN` werkend te krijgen.[^44_1]

<div align="center">⁂</div>

[^44_1]: https://home-assistant-china.github.io/developers/hassio/addon_config/


---

# ➜  open-webui git:(main) ✗ cd /tmp/hassio-addons/open-webui

# Bekijk de huidige run.sh

cat run.sh

➜  open-webui git:(main) ✗ \# Check of Dockerfile er is en wat erin staat
cat Dockerfile

# File: Dockerfile

# This wrapper image starts from the pre-built image and adds

# the necessary Home Assistant labels and a custom startup script.

ARG BUILD_FROM
FROM ghcr.io/open-webui/open-webui:v0.7.2

# Labels for Home Assistant Supervisor

LABEL \\
io.hass.version="v0.7.2" \\
io.hass.type="addon" \\
io.hass.arch="aarch64|amd64"

# By default, expose the same port

EXPOSE 8080

ENV DATA_DIR=/data

COPY open-webui/run.sh .
RUN chmod a+x run.sh

# Run the wrapper script on startup

\# CMD [ "/run.sh" ]
➜  open-webui git:(main) ✗

Goed! De Dockerfile is er, maar `run.sh` is leeg. We moeten een startup script maken dat:

1. De environment variables doorgeeft
2. Open WebUI start

Maak de `run.sh`:

```bash
cd /tmp/hassio-addons/open-webui

cat > run.sh << 'EOF'
#!/bin/bash
set -e

echo "Starting Open WebUI with custom settings..."
echo "JWT_EXPIRES_IN: ${JWT_EXPIRES_IN}"

# Export environment variables
export JWT_EXPIRES_IN="${JWT_EXPIRES_IN:-5m}"
export DATA_DIR="${DATA_DIR:-/data}"

# Start Open WebUI
exec bash /app/backend/start.sh
EOF

chmod +x run.sh
```

Nu moet je ook de Dockerfile aanpassen om het CMD te activeren:

```bash
nano Dockerfile
```

Verwijder de `#` voor de CMD regel (onderaan):

```dockerfile
# Run the wrapper script on startup
CMD [ "/run.sh" ]
```

Push alles:

```bash
git add run.sh Dockerfile config.yaml
git commit -m "Add run.sh and fix Dockerfile CMD"
git push

ha supervisor reload
```

Wacht 20 seconden en check of de add-on nu verschijnt in de store.[^45_1][^45_2]

<div align="center">⁂</div>

[^45_1]: https://home-assistant-china.github.io/developers/hassio/addon_config/

[^45_2]: https://developers.home-assistant.io/docs/add-ons/configuration/

