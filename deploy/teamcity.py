import click
from build_helper.docker import DockerComposeSession


@click.group(chain=True)
@click.pass_context
def app(ctx):
    ctx.obj = {}


@app.command()
@click.pass_context
def tox(ctx):
    with DockerComposeSession(
        compose_files=(
            'docker-compose.yml',
        ),
    ) as service:
        if not ctx.obj.get('built_tests'):
            service.build()
            ctx.obj['built_tests'] = True
        service.run(
            '--no-deps',
            'tests',
            'tox',
        )


@app.command()
@click.pass_context
def tests(ctx):
    with DockerComposeSession(
        compose_files=(
            'docker-compose.yml',
        ),
    ) as service:
        if not ctx.obj.get('built_tests'):
            service.build()
            ctx.obj['built_tests'] = True
        service.run(
            '--no-deps',
            'tests',
            './runtests.sh',
        )


@app.command()
@click.pass_context
def build(ctx):
    with DockerComposeSession(
        compose_files=(
            'docker-compose.yml',
        ),
    ) as service:
        if not ctx.obj.get('built_tests'):
            service.build()
            ctx.obj['built_tests'] = True
        service.run(
            '--no-deps',
            'tests',
            'python3',
            '-m',
            'build',
        )


if __name__ == '__main__':
    app()
