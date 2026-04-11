# Stage 1: Build the Flutter web application
# Using instrumentisto/flutter as it is highly compatible with Ubuntu builds
FROM instrumentisto/flutter:latest AS build-env

WORKDIR /app

# Copy dependency files first to leverage Docker cache
COPY pubspec.yaml ./
RUN flutter pub get

# Copy the entire project and build for web
COPY . .
RUN flutter build web --release

# Stage 2: Serve the app using Nginx
FROM nginx:alpine

# Copy the static web files from the build stage to Nginx
COPY --from=build-env /app/build/web /usr/share/nginx/html

# Expose port 80 for the browser
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
