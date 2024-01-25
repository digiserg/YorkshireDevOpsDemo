# Intro

This is the code used for the demo of my presentation `Dynamic Database Credentials in Kubernetes`

[Talk slides here](Dynamic%20Credentials%20with%20Vals-Operator.pdf)

## Setup

### Prep

```sh
export K3S_TOKEN=${RANDOM}${RANDOM}${RANDOM}
docker-compose up -d
```

### Install stage01

```sh
cd stage01
terraform init
terraform apply
```

### Init Vault

** Save the output **

```
kubectl exec -ti -n vault vault-0 -- vault operator init
```

Edit the `unseal.sh` and add your unseal keys there. Then, edit the `env.sh` and add the vault token.

Because we have no ingress, you'll need port forwarding to access vault:

```sh
kubectl port-forward -n vault svc/vault 8200:8200 &
```

Then run the `unseal.sh`

```sh
source env.sh
./unseal.sh
# check vault is up and running and unsealed
vault status
```

### Install stage02

```sh
source env.sh
cd stage02
terraform init
terraform apply -var=vault_token=$VAULT_TOKEN
```

## Check it's all good

```sh
kubectl po -A
```

You should see the `mariadb` and `postgres` databases running.