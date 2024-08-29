.PHONY: clean zip delete create update invoke log test objects upload download
PROJECT_DIR=$(shell pwd)

clean:
	if [ -f lambda.zip ]; then rm lambda.zip; fi

zip:clean
	pipenv requirements > requirements.txt
	cd $(PROJECT_DIR)/src && zip -r $(PROJECT_DIR)/lambda.zip *
	cd $(PROJECT_DIR)
	find lambda.zip

delete:
	aws --endpoint-url=http://localhost:3566 \
    --region ap-northeast-1 --profile localstack lambda delete-function \
    --function-name=http-test-function 

create:zip
	aws lambda create-function \
    --function-name=http-test-function \
    --runtime=python3.12 \
		--role=arn:aws:iam::000000000000:role/test \
    --handler=handler.main \
    --zip-file fileb://lambda.zip \
		--region ap-northeast-1 \
    --endpoint-url=http://localhost:3566 \
		--profile localstack

update:zip
	aws lambda update-function-code \
    --function-name=http-test-function  \
    --zip-file fileb://lambda.zip \
		--region ap-northeast-1 \
    --endpoint-url=http://localhost:3566 \
		--profile localstack 

invoke:
	aws lambda invoke \
		--endpoint-url=http://localhost:3566 \
		--function-name=http-test-function  \
		--region ap-northeast-1 \
		--payload '{}' \
		--cli-binary-format raw-in-base64-out \
		--profile localstack result.log

log:
	cat result.log

test:
	pipenv run test

objects:
	aws s3 ls s3://pipenv-dev/$(OBJ_PATH) \
		--endpoint-url=http://localhost:3566 \
		--profile localstack

upload:
	aws s3 cp $(FILE_PATH) s3://pipenv-dev/$(FILE_PATH) \
		--endpoint-url=http://localhost:3566 \
		--profile localstack

download:
	aws s3 cp s3://pipenv-dev/$(FILE_PATH) ./tmp/$(FILE_PATH) \
		--endpoint-url=http://localhost:3566 \
		--profile localstack
