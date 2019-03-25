# kafka role usage guide
- https://github.com/macunha1/confluent-kafka-role

## Change some task settings
### add sudo to some task (become: yes)
- download kafka files to /opt
- copy configurations to /opt/kafka ...

### change zookeeper setting in server.properties
- 멀티 zookeeper를 기준으로 생성되어,
- 단일 zookeeper인 경우, ","가 붙게 된다.
- 따라서 단일인 경우 해당 설정을 변경함. (default/main.yml)
```yml
zookeeper_group: "{{ groups['zookeeper'] | default(ansible_play_hosts) }}"
zookeepers: >
  "{% for server in zookeeper_group -%}
  {{ hostvars.get(server).ansible_all_ipv4_addresses | first }}:{{ zookeeper_port }}
  {% endfor %}"
zookeeper_port: 2181
# zookeeper_connect: "{{ zookeepers.split() | join(',') }}"
zookeeper_connect: "{{ hostvars['server2'].ansible_ssh_host }}:{{ zookeeper_port }}"
```

### create topics command
- topic이 생성에 필요한 옵션이 제대로 인식되지 않아,
- 직접 command를 실행하도록 변경
```yml
- name: Create a new partitioned topic on Kafka
  command: >
    {{ kafka_bins }}/kafka-topics
    --zookeeper localhost:2181
    --create --replication-factor {{ default_replication_factor }} --partitions 1
    --topic {{ item }}
```


## Run test command

'''shell
> /opt/confluent-3.3.0/bin/kafka-topics --list --zookeeper localhost:2181
> /opt/confluent-3.3.0/bin/kafka-topics --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic test

> ./bin/kafka-consumer-groups --bootstrap-server localhost:9092 --command-config ~/.ccloud/config --list  _confluent-healthcheck  example-group

'''

## ETC
### JMX PORT Enable
### ADD JMX_PORT option kafka.service (이 방식은 오류 발생)
### 오류 원인
- 아래 ansible code에서 service갯수만큼 systemd.service.j2를 복사하는데,
- JMX_PORT를 동일하게 하면, port 충돌이 발생하여 kafka 서비스가 동작하지 않는다.
- 따라서 해당 코드는 약간의 수작업이 필요
```yml
- name: Create Systemd services unit
  become: yes
  template:
    src: systemd.service.j2
    dest: "/etc/systemd/system/{{ item.value.file_name }}.service"
    mode: 0640
    group: wheel
    force: yes
  with_dict: "{{ services }}"
```


- templates/systemd.servie.j2 파일에서 [service] 아래에 JMX_PORT설정 추가
```
Environment=JMX_PORT=9999
```

- restart kafka
```
> systemctl daemon-reload
> systemctl restart kafka

# jmx 적용 확인
> netstat -an | grep 9999
tcp6       0      0 :::9999                 :::*                    LISTEN     
tcp6       0      0 ::1:9999                ::1:59758               TIME_WAIT  
```
#### JMX_PORT 설정 후, service 시작이 안되는 경우
- jmx port가 사용중인지 확인하고,
- 해당 프로세스를 중지한다.
```
> sudo ss -lptn 'sport = :9999'
State       Recv-Q Send-Q                             Local Address:Port                                            Peer Address:Port              
LISTEN      0      50                                            :::9999                                                      :::*                   users:(("java",pid=2215,fd=99))
>  kill -9 2215
```
