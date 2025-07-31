FROM node:24-alpine3.21

WORKDIR /app

COPY ./package.json /app/package.json

RUN corepack enable pnpm

RUN apk add fish

RUN mkdir -p /root/.config/fish/functions/ &&  printf 'function fish_prompt  \n\
  set -l last_status $status  \n\
    set -l stat  \n\
    if test $last_status -ne 0  \n\
        set stat (set_color red)" [$last_status]"(set_color normal)  \n\
    end  \n\
    string join "" -- (set_color green) "[frontend] " $PWD (set_color normal) $stat " >"  \n\
end' > /root/.config/fish/functions/fish_prompt.fish 

RUN pnpm store add @vitejs/plugin-vue@5.2.4 \
                    pinia@3.0.3 \
                    pinia-plugin-persistedstate@4.3.0 \
                    @formkit/vue@1.6.9 \
                    @formkit/i18n@1.6.9 \
                    vue@3.5.16 \
                    vue-i18n@11.1.6 \
                    vue-router@4.5.1 \
                    unplugin-vue-router@0.12.0 \
                    axios@1.10.0 \
                    vite@6.3.5 \
                    vite-plugin-vue-devtools@7.7.7 \
                    tailwindcss@4.1.10 \
                    @tailwindcss/vite@4.1.10 \
                    shadcn-vue@2.2.0 \
                    class-variance-authority@0.7.1 \
                    clsx@2.1.1 \
                    lucide-vue-next@0.516.0 \
                    tailwind-merge@3.3.1 \
                    tw-animate-css@1.3.4 \
                    @vueuse/core@13.0.0 \
                    reka-ui@2.3.1 \
                    @tanstack/vue-table@8.21.3 
                    
RUN pnpm i

CMD ["pnpm", "dev"]