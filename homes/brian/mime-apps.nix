{
  xdg.mimeApps = {
    enable = true;
    defaultApplications =
      let
        web = "firefox.desktop";
        multimedia = "mpv.desktop";
        image = "org.kde.gwenview.desktop";
        directory = "com.system76.CosmicFiles.desktop";
        text = "com.system76.CosmicEdit.desktop";
        pdf = "com.system76.CosmicReader.desktop";
      in
      {
        # web - firefox
        "text/html" = web;
        "application/xhtml+xml" = web;
        "x-scheme-handler/http" = web;
        "x-scheme-handler/https" = web;
        "x-scheme-handler/about" = web;
        "x-scheme-handler/unknown" = web;

        # multimedia - umpv
        "audio/aac" = multimedia;
        "audio/flac" = multimedia;
        "audio/mp4" = multimedia;
        "audio/mpeg" = multimedia;
        "audio/ogg" = multimedia;
        "audio/opus" = multimedia;
        "audio/wav" = multimedia;
        "audio/webm" = multimedia;
        "audio/x-m4a" = multimedia;
        "audio/x-vorbis+ogg" = multimedia;
        "audio/x-wav" = multimedia;
        "video/3gpp" = multimedia;
        "video/mp4" = multimedia;
        "video/mpeg" = multimedia;
        "video/ogg" = multimedia;
        "video/quicktime" = multimedia;
        "video/webm" = multimedia;
        "video/x-flv" = multimedia;
        "video/x-matroska" = multimedia;
        "video/x-ms-wmv" = multimedia;
        "video/x-msvideo" = multimedia;

        # image - gwenview
        "image/avif" = image;
        "image/bmp" = image;
        "image/gif" = image;
        "image/heif" = image;
        "image/jpeg" = image;
        "image/jxl" = image;
        "image/png" = image;
        "image/svg+xml" = image;
        "image/tiff" = image;
        "image/webp" = image;

        # directory - cosmic files
        "inode/directory" = directory;

        # generic text - cosmic edit
        "text/plain" = text;

        # pdf - cosmic reader
        "application/pdf" = pdf;

        # discord - vesktop
        "x-scheme-handler/discord" = "vesktop.desktop";
      };
  };
}
