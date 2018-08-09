#!/bin/sh

echo "Installing Cocoapod dependencies..."
pod install
echo "Done"

echo "Cleaning BoringSSL module.modulemap..."
> Pods/BoringSSL/include/openssl/module.modulemap
echo "Done"

echo "Fixing bad imports in Protobuf generated files..."
grep -rl "google/cloud/speech/v1beta1/CloudSpeech.pbobjc.h"  google/** | xargs sed -i '' s@'"google\/cloud\/speech\/v1beta1\/CloudSpeech\.pbobjc\.h"'@'\<googleapis\/CloudSpeech\.pbobjc\.h\>'@g
grep -rl "google/api/Annotations.pbobjc.h"  google/** | xargs sed -i '' s@'"google\/api\/Annotations\.pbobjc\.h"'@'\<googleapis\/Annotations\.pbobjc\.h\>'@g
grep -rl "google/longrunning/Operations.pbobjc.h"  google/** | xargs sed -i '' s@'"google\/longrunning\/Operations\.pbobjc\.h"'@'\<googleapis\/Operations\.pbobjc\.h\>'@g
grep -rl "google/rpc/Status.pbobjc.h"  google/** | xargs sed -i '' s@'"google\/rpc\/Status\.pbobjc\.h"'@'\<googleapis\/Status\.pbobjc\.h\>'@g
grep -rl "google/cloud/speech/v1/CloudSpeech.pbobjc.h"  google/** | xargs sed -i '' s@'"\google\/cloud\/speech\/v1\/CloudSpeech\.pbobjc\.h\"'@'\<googleapis\/CloudSpeech\.pbobjc\.h\>'@g
echo "Done"

echo "Fixing bad gRPC-RxLibrary-umbrella.h import..."
sed -i .bac 's/transformations\///g' Pods/Target\ Support\ Files/gRPC-RxLibrary/gRPC-RxLibrary-umbrella.h
rm Pods/Target\ Support\ Files/gRPC-RxLibrary/gRPC-RxLibrary-umbrella.h.bac
echo "Done"

echo "Fixing bad gRPC-umbrella.h import..."
sed -i .bac 's/#import\ "internal_testing\/GRPCCall+InternalTests.h"//g' Pods/Target\ Support\ Files/gRPC/gRPC-umbrella.hrm Pods/Target\ Support\ Files/gRPC/gRPC-umbrella.h.bac
echo "Done"

echo "Install completed!"
