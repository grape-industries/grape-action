# Grape Reindex

This action re-indexes a [Grape](https://grape-inc.in) project after a push. Then search, MCP and the chatbot use the newest files of the repository.

The project must be a GitHub project in Grape. Grape clones the repository again. If the commit is already indexed, Grape skips the clone.

## Set up

1. In Grape, open the project. Copy the project ID.
2. In Grape, open **API keys**. Copy your API key.
3. In the repository on GitHub, open **Settings**, then **Secrets and variables**, then **Actions**.
4. Add a secret with the name `GRAPE_API_KEY`. Paste the API key as the value.
5. Add this file as `.github/workflows/grape.yml`:

```yaml
name: grape
on:
  push:
    branches: [main]
jobs:
  reindex:
    runs-on: ubuntu-latest
    steps:
      - uses: grape-industries/grape-action@v1
        with:
          project: <project id>
          token: ${{ secrets.GRAPE_API_KEY }}
```

The project's **Connect** tab in Grape shows this file with your project ID and branch.

## Inputs

| Input | Required | Default | Description |
| --- | --- | --- | --- |
| `project` | Yes | | The Grape project ID. |
| `token` | Yes | | Your Grape API key. Keep it in a secret. |
| `branch` | No | The pushed branch | The branch to re-index. |
| `url` | No | `https://grape-inc.in` | The Grape address. |

## Branch

A Grape project follows one branch. If you send a different branch, Grape returns an error and the step fails. Use `branches:` in the workflow to run the action only on that branch. To change the branch, open the project's **Settings** tab in Grape.

## Errors

The step fails and shows Grape's message when:
- the branch is not the branch that the project follows;
- the project is not a GitHub project;
- the API key is wrong (401) or the project ID is wrong (404);
- there were more than 30 re-index calls for the project in one hour (429).

## License

MIT
