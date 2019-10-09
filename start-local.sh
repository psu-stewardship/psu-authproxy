#!/bin/bash

export POSTGRES_PASSWORD=psuauthproxy
export POSTGRES_HOST=127.0.0.1
export POSTGRES_PORT=5433

rails db:migrate

rails s -p 3001
