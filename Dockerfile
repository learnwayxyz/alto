FROM node:20.12.2-alpine3.19 AS production

WORKDIR /app

RUN npm install -g typescript

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml* ./

RUN corepack enable

COPY . .

RUN pnpm fetch

RUN pnpm install -r --offline --frozen-lockfile

RUN pnpm build

# This is needed for backwards compatibility
# alto.js was previously in /src/lib/cli but is now in /src/esm/cli after changing to ESM
RUN mkdir -p /app/src/lib/cli && ln -sf /app/src/esm/cli/alto.js /app/src/lib/cli/alto.js

ENTRYPOINT ["pnpm", "start"]
