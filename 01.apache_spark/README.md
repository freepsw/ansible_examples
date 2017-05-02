## run apache spark
- https://github.com/slaclab/ansible-role-spark 참고
- system service로 등록하여 master, worker를 구동하는 방식
```
> ansible-playbook -i staging spark.yml (role을 ansible-spark로 변경)
```

## run apache spark (dev version)
- master node에서 start-all.sh로 클러스터를 구축하는 방식 (간단)
```
> ansible-playbook -i staging spark.yml (role을 ansible-spark로 변경)
```
