import os
from azure.identity import DeviceCodeCredential

GRAPH_SCOPE = "https://graph.microsoft.com/.default"


def get_graph_token():
    tenant_id = "66f15b3d-3ce8-4e2f-8e25-5db984fb6416"
    client_id = "14d82eec-204b-4c2f-b7e8-296a70dab67e"

    credential = DeviceCodeCredential(
        tenant_id=tenant_id,
        client_id=client_id
    )

    token = credential.get_token(GRAPH_SCOPE)

    return token.token


def graph_headers():
    token = get_graph_token()

    return {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json",
    }
