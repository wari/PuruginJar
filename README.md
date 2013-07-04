PuruginJar
==========

### What is this?

The script in this repo checks for an update to the [Purugin]("http://github.com/enebo/purugin")
Repository. If it has changed, it will download it, use mvn(Compiler) to create the .jar file, and place
it in this repo, and update it.

#### Notes

This is pretty bad code. It's mainly for my own use, but please submit a pull request and fix my hacky
code.

#### Todo:

1. Use Github API instead of scraping page.
2. Structure the script into a class.
3. Make it easy to use from another script to download purugin(possibly other java source code)

