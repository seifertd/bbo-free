# bbo-free
Small Rails Website to Collect and Combine Results from Bridge Base Online tournaments and rescore them

## Data Model
┌────────────────────┐         ┌──────────────────┐         ┌───────────────────┐
│     Tournament     │         │      Entry       │         │      Board        │
├────────────────────┤         ├──────────────────┤         ├───────────────────┤
│                    │         │player:string     │         │number:integer     │
│name:string         │1       *│played_at:date    │1       *│played_at:datetime │
│guid:string         ├────────►│score:decimal     ├────────►│points:integer     │
│tourney_date:date   │         │rank:integer      │         │score:decimal      │
│                    │         │                  │         │result:string      │
│                    │         │                  │         │                   │
└────────────────────┘         └──────────────────┘         └───────────────────┘
