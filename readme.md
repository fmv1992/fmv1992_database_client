# `fmv1992_database_client`

A client for the [`fmv1992_database`](https://github.com/fmv1992/fmv1992_database) project.

High level actions:

*   Backup: backup a folder recursively.

    *   Maybe using an interactive option alongside a batch option is a good idea, cf. `fmv1992_blobs_put_file_interactive`.

    *   Special considerations:

        *   Git folders should be backed up in a special way. We shall not backup on a file-by-file basis.

*   Restore a folder.

    *   For ease of use a special file format should be used. See [`my_publications`](https://github.com/fmv1992/my_publications/blob/9fc8f9b1c9e1ac33869c7efa28748cbbe9f1290f/index.csv#L1) for a possible file format.

    *   Behavior:

        *   Overwrite flag.

        *   Zap flag: should we remove everything that is defined in that folder that is not part of the "index" file?

*   Delete files from the database.

    *   For simplicity a file api should be used. Perhaps a single list of IDs should do the trick.

## APIs

### General

<!-- vim: set filetype=pandoc fileformat=unix nowrap spell spelllang=en:  -->
