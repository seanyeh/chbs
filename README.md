# chbs

chbs - Correct Horse Battery Staple passphrase generator

Uses the [EFF wordlist](https://www.eff.org/files/2016/07/18/eff_large_wordlist.txt) (7,776 words)

## Usage

```bash
# Generate and output a 5-word passphrase separated by hyphens
chbs

# Customize number of words and separator
chbs -n 6 -s " "

# Copy generated passphrase to clipboard
chbs -c
```

## License

MIT
