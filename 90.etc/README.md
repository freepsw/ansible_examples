# Run ansible example


## run ssh role
```
> ansible-playbook  -i staging ssh.yml --ask-pass
```

## install docker specific version (1.12.6)
```
> ansible-playbook -i staging docker.yml
```

## install docker-ce
- https://github.com/avinetworks/ansible-role-docker/tree/3c1ef981f6cdcbe0f3d49c7c896801ae4e8f847d/tasks/ce/os

### docker version 확인
- 아래 명령어에서 2번째 문자(17.03.0.el7)가 ansible yum name에 들어갈 버전명이 된다.
```
> yum list docker-ce.x86_64  --showduplicates |sort -r

docker-ce.x86_64  17.03.0.el7                               docker-ce-stable  
```

- 인터넷이 안되는 곳에서는 rpm을 이용한 설치도 ansible로 정리하면 좋을 듯
