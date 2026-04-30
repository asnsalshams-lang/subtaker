#!/bin/bash

# Define Colors
CRITICAL='\033[1;35m' # Bold Purple
HIGH='\033[0;31m'     # Red
INFO='\033[0;34m'     # Blue
NC='\033[0m'          # No Color

output_file="recon_providers.txt"
> "$output_file"

while IFS= read -r sub || [ -n "$sub" ]; do
    sub=$(echo "$sub" | tr -d '\r' | xargs)
    [[ -z "$sub" ]] && continue

    cname=$(dig +short CNAME "$sub" | tail -n1)
    
    # Identify the Provider based on the CNAME string
    provider="UNKNOWN"
    if [[ "$cname" =~ "hubspot" ]]; then provider="HUBSPOT";
    elif [[ "$cname" =~ "s3.amazonaws" ]]; then provider="AWS-S3";
    elif [[ "$cname" =~ "github.io" ]]; then provider="GITHUB-PAGES";
    elif [[ "$cname" =~ "herokudns" ]]; then provider="HEROKU";
    elif [[ "$cname" =~ "azure" ]]; then provider="AZURE";
    elif [[ "$cname" =~ "cloudfront" ]]; then provider="CLOUDFRONT";
    elif [[ "$cname" =~ "wpengine" ]]; then provider="WP-ENGINE";
    elif [[ "$cname" =~ "shopify" ]]; then provider="SHOPIFY";
    fi

    # Display Output
    if [ "$provider" != "UNKNOWN" ]; then
        echo -e "${CRITICAL}[!] $sub -> [$provider]${NC} ($cname)"
        echo "$sub: $provider ($cname)" >> "$output_file"
    elif [ -n "$cname" ]; then
        echo -e "${INFO}[+] $sub -> CNAME: $cname${NC}"
    fi

done < live_subdomains_resolved.txt
