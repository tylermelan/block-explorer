# Block Explorer

A Ruby on Rails application for exploring transactions from a simulated NEAR blockchain.

## Dependencies & Versions

- **Ruby:** 3.4.2
- **Rails:** 8.0.2
- **PostgreSQL**

## Setup

1. **Install gems and set up the database:**

   ```bash
   bin/bundle install
   bin/rails db:setup
   ```

2. **Set the BLOCKCHAIN\_API\_KEY environment variable:**

   ```bash
   export BLOCKCHAIN_API_KEY=your_api_key_here
   ```

3. **Run the development server:**

   ```bash
   bin/rails dev
   ```

## Architecture Overview

The architecture decouples fetching transactions from the API and handling user requests. 

For user requests, the database serves as the source of truth. This approach ensures the UI remains responsive and fast, as it only depends on the database and does not wait on API responses. This also means that user requests are unaffected if the API experiences downtime.

For fetching transactions from the API, a recurring job (`BlockchainSyncJob`) runs every minute. This job fetches the latest data and synchronizes the database to reflect the newest transactions.

### Database Synchronization

The synchronization logic is managed by `BlockchainSyncService`, leveraging `insert_all` for efficient bulk insertion. The service:

- Checks which `blocks` and `block_transactions` are already present in the database.
- Constructs arrays containing only new records, which are then passed to `insert_all`.

Benchmarking showed that this method is approximately **30 times faster** than using `find_or_create_by`.

### Handling User Requests

The `BlockTransactionsController` uses the database exclusively, simplifying data retrieval. This eliminates the need to mix API and database calls.

For obtaining transaction details like `sender`, `receiver`, and `deposit`, the controller executes a simple database query joining `block_transactions` and `actions` where the `action_type` is `Transfer`.
