FROM node:24-alpine3.24

# 1. Rendszer szintű függőségek és Corepack beállítása (root-ként fut)
RUN corepack enable pnpm
RUN apk add --no-cache fish

# 2. Munkakönyvtár létrehozása és tulajdonjog átadása a 'node' felhasználónak
RUN mkdir -p /app && chown -R node:node /app

# 3. Munkakönyvtár kijelölése
WORKDIR /app

# 4. Váltás a korlátozott jogú felhasználóra
USER node

# 5. Fish prompt beállítása
RUN mkdir -p /home/node/.config/fish/functions/ &&  printf 'function fish_prompt  \n\
  set -l last_status $status  \n\
    set -l stat  \n\
    if test $last_status -ne 0  \n\
        set stat (set_color red)" [$last_status]"(set_color normal)  \n\
    end  \n\
    string join "" -- (set_color green) "[frontend] " $PWD (set_color normal) $stat " >"  \n\
end' > /home/node/.config/fish/functions/fish_prompt.fish 

# 6. A package.json fájl bemásolása a megfelelő jogosultságokkal
COPY --chown=node:node package.json ./
COPY --chown=node:node pnpm-workspace.yaml ./

# 7. Függőségek telepítése (most már van írási joga a Corepack-nek az /app mappába)
RUN pnpm i

CMD ["pnpm", "dev"]