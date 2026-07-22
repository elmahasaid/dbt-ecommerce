# 🛒 dbt E-commerce — Silver/Gold Pipeline sur BigQuery

Pipeline de transformation de données construit avec **dbt** sur **Google BigQuery**, à partir du dataset public [`thelook_ecommerce`](https://console.cloud.google.com/marketplace/product/bigquery-public-data/thelook-ecommerce). Le projet applique une architecture en couches (Staging → Silver → Gold), avec tests de données automatisés, documentation générée, et intégration continue via GitHub Actions.

## 🏗️ Architecture
Source (BigQuery public dataset)
│
▼
Staging (vues) → renommage, typage, 1 modèle par table source
│
▼
Silver (tables) → jointures, enrichissement, logique métier simple
│
▼
Gold (tables) → marts métier prêts à l'analyse

### Couche Staging
Un modèle par table source, matérialisé en vue : `stg_users`, `stg_orders`, `stg_order_items`, `stg_products`, `stg_inventory_items`, `stg_distribution_centers`.

### Couche Silver
- `slv_orders_enriched` — une ligne par article commandé, enrichie des infos produit et de la marge brute
- `slv_customers` — une ligne par client, avec statistiques agrégées de commandes

### Couche Gold
- `gld_revenue_by_month` — chiffre d'affaires mensuel, panier moyen
- `gld_customer_ltv` — valeur vie client et segmentation (nouveau / récurrent / VIP)
- `gld_inventory_status` — état du stock par produit (unités vendues, en stock, valeur du stock)

## ✅ Qualité des données

34 tests dbt (`unique`, `not_null`, `relationships`, `accepted_values`) répartis sur les trois couches, garantissant l'intégrité référentielle du pipeline.

```bash
dbt build
```

## 📚 Documentation

Documentation générée automatiquement avec lignage complet des colonnes :

```bash
dbt docs generate
dbt docs serve
```

## 🔄 CI/CD

Un workflow GitHub Actions (`.github/workflows/ci.yml`) exécute automatiquement `dbt build` à chaque push et pull request sur `main`, garantissant qu'aucune modification cassée ne peut être intégrée.

L'authentification à BigQuery se fait via **Workload Identity Federation** — aucune clé de service account n'est stockée dans le repo ou dans les secrets GitHub.

## 🚀 Lancer le projet en local

### Prérequis
- Python 3.9+
- Un projet Google Cloud avec BigQuery activé
- [gcloud CLI](https://cloud.google.com/sdk/docs/install) installé et authentifié

### Installation

```bash
git clone https://github.com/elmahasaid/dbt-ecommerce.git
cd dbt-ecommerce/dbt_ecommerce

python -m venv venv
venv\Scripts\activate        # Windows
# source venv/bin/activate   # macOS/Linux

pip install dbt-bigquery

gcloud auth application-default login

dbt debug
dbt build
```

## 🛠️ Stack technique

- **dbt-core** 1.12
- **BigQuery** (dbt-bigquery adapter)
- **GitHub Actions** (CI/CD)
- **Workload Identity Federation** (authentification sans clé)

## 📊 Source des données

[The Look E-commerce](https://console.cloud.google.com/marketplace/product/bigquery-public-data/thelook-ecommerce) — dataset public simulant une plateforme e-commerce de vêtements (utilisateurs, commandes, produits, stock, centres de distribution).