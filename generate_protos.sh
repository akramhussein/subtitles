#/bin/sh

./Pods/\!ProtoCompiler/protoc --objc_opt=named_framework_to_proto_path_mappings_path=./protomap \
    --plugin=protoc-gen-grpc=./Pods/\!ProtoCompiler-gRPCPlugin/grpc_objective_c_plugin \
    --objc_out=. \
    --grpc_out=. \
    -I . \
    -I ./Pods/\!ProtoCompiler/ \
    google/*/*.proto google/*/*/*/*.proto
