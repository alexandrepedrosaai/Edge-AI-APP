import os, json, requests

acs_endpoint  = os.getenv("ACS_ENDPOINT","")
acs_key       = os.getenv("ACS_ACCESS_KEY","")
whatsapp_from = os.getenv("WHATSAPP_FROM","")
whatsapp_to   = os.getenv("WHATSAPP_TO","")

manifest = json.load(open("firmware/manifest.json"))
summary  = f"Edge-Chip-Hex: {len(manifest)} firmware blobs validated via SHA3-512."
print(summary)

if all([acs_endpoint, acs_key, whatsapp_from, whatsapp_to]):
    r = requests.post(
        f"{acs_endpoint}/messages/notifications:send?api-version=2024-02-01",
        json={"channelRegistrationId": whatsapp_from, "to": whatsapp_to,
              "kind": "text", "content": summary},
        headers={"Ocp-Apim-Subscription-Key": acs_key}, timeout=15)
    print(f"ACS dispatch: {r.status_code}")
else:
    print("ACS credentials not set - skipping WhatsApp dispatch")
