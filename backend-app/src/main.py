import boto3
import json
import time
import math


sqs = boto3.resource("sqs")
sqs_queue = sqs.get_queue_by_name(QueueName="klele")

def process_message(message_body):
    print(f"processing message: {message_body}")
    pass

def cpu_heavy(metadata):
    print(f"Processing cpu_heavy task! {metadata}")
    count = metadata['count']
    counter = 0
    while counter < count:
        a = math.sqrt(64*64*64*64*64)
        counter += 1

    print(f"Done!")



def time_heavy(metadata):
    print(f"Processing time_heavy task! {metadata}")
    time.sleep(metadata['wait_time'])
    print(f"Done time_heavy task! {metadata}")
    pass

msg_types_map = {
    'cpu_heavy': cpu_heavy,
    'time_heavy': time_heavy,
}


if __name__ == "__main__":
    import pdb; pdb.set_trace()
    while True:
        messages = sqs_queue.receive_messages(WaitTimeSeconds=5)
        for message in messages:
            try:
                msg = json.loads(message.body)
                processor = msg_types_map[msg['type']]
                processor(msg['metadata'])
            except Exception as e:
                print(f"exception while processing message: {repr(e)}")
                continue

            message.delete()
