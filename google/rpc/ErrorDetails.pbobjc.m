// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: google/rpc/error_details.proto

// This CPP symbol can be defined to use imports that match up to the framework
// imports needed when using CocoaPods.
#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <Protobuf/GPBProtocolBuffers_RuntimeSupport.h>
#else
 #import "GPBProtocolBuffers_RuntimeSupport.h"
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <Protobuf/Duration.pbobjc.h>
#else
 #import <googleapis/Duration.pbobjc.h>
#endif

 #import <googleapis/ErrorDetails.pbobjc.h>
// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - ErrorDetailsRoot

@implementation ErrorDetailsRoot

+ (GPBExtensionRegistry*)extensionRegistry {
  // This is called by +initialize so there is no need to worry
  // about thread safety and initialization of registry.
  static GPBExtensionRegistry* registry = nil;
  if (!registry) {
    GPBDebugCheckRuntimeVersion();
    registry = [[GPBExtensionRegistry alloc] init];
    [registry addExtensions:[GPBDurationRoot extensionRegistry]];
  }
  return registry;
}

@end

#pragma mark - ErrorDetailsRoot_FileDescriptor

static GPBFileDescriptor *ErrorDetailsRoot_FileDescriptor(void) {
  // This is called by +initialize so there is no need to worry
  // about thread safety of the singleton.
  static GPBFileDescriptor *descriptor = NULL;
  if (!descriptor) {
    GPBDebugCheckRuntimeVersion();
    descriptor = [[GPBFileDescriptor alloc] initWithPackage:@"google.rpc"
                                                     syntax:GPBFileSyntaxProto3];
  }
  return descriptor;
}

#pragma mark - RetryInfo

@implementation RetryInfo

@dynamic hasRetryDelay, retryDelay;

typedef struct RetryInfo__storage_ {
  uint32_t _has_storage_[1];
  GPBDuration *retryDelay;
} RetryInfo__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "retryDelay",
        .dataTypeSpecific.className = GPBStringifySymbol(GPBDuration),
        .number = RetryInfo_FieldNumber_RetryDelay,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(RetryInfo__storage_, retryDelay),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[RetryInfo class]
                                     rootClass:[ErrorDetailsRoot class]
                                          file:ErrorDetailsRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(RetryInfo__storage_)
                                         flags:0];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - DebugInfo

@implementation DebugInfo

@dynamic stackEntriesArray, stackEntriesArray_Count;
@dynamic detail;

typedef struct DebugInfo__storage_ {
  uint32_t _has_storage_[1];
  NSMutableArray *stackEntriesArray;
  NSString *detail;
} DebugInfo__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "stackEntriesArray",
        .dataTypeSpecific.className = NULL,
        .number = DebugInfo_FieldNumber_StackEntriesArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(DebugInfo__storage_, stackEntriesArray),
        .flags = GPBFieldRepeated,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "detail",
        .dataTypeSpecific.className = NULL,
        .number = DebugInfo_FieldNumber_Detail,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(DebugInfo__storage_, detail),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[DebugInfo class]
                                     rootClass:[ErrorDetailsRoot class]
                                          file:ErrorDetailsRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(DebugInfo__storage_)
                                         flags:0];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - QuotaFailure

@implementation QuotaFailure

@dynamic violationsArray, violationsArray_Count;

typedef struct QuotaFailure__storage_ {
  uint32_t _has_storage_[1];
  NSMutableArray *violationsArray;
} QuotaFailure__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "violationsArray",
        .dataTypeSpecific.className = GPBStringifySymbol(QuotaFailure_Violation),
        .number = QuotaFailure_FieldNumber_ViolationsArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(QuotaFailure__storage_, violationsArray),
        .flags = GPBFieldRepeated,
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[QuotaFailure class]
                                     rootClass:[ErrorDetailsRoot class]
                                          file:ErrorDetailsRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(QuotaFailure__storage_)
                                         flags:0];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - QuotaFailure_Violation

@implementation QuotaFailure_Violation

@dynamic subject;
@dynamic description_p;

typedef struct QuotaFailure_Violation__storage_ {
  uint32_t _has_storage_[1];
  NSString *subject;
  NSString *description_p;
} QuotaFailure_Violation__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "subject",
        .dataTypeSpecific.className = NULL,
        .number = QuotaFailure_Violation_FieldNumber_Subject,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(QuotaFailure_Violation__storage_, subject),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "description_p",
        .dataTypeSpecific.className = NULL,
        .number = QuotaFailure_Violation_FieldNumber_Description_p,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(QuotaFailure_Violation__storage_, description_p),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[QuotaFailure_Violation class]
                                     rootClass:[ErrorDetailsRoot class]
                                          file:ErrorDetailsRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(QuotaFailure_Violation__storage_)
                                         flags:0];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - BadRequest

@implementation BadRequest

@dynamic fieldViolationsArray, fieldViolationsArray_Count;

typedef struct BadRequest__storage_ {
  uint32_t _has_storage_[1];
  NSMutableArray *fieldViolationsArray;
} BadRequest__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "fieldViolationsArray",
        .dataTypeSpecific.className = GPBStringifySymbol(BadRequest_FieldViolation),
        .number = BadRequest_FieldNumber_FieldViolationsArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(BadRequest__storage_, fieldViolationsArray),
        .flags = GPBFieldRepeated,
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[BadRequest class]
                                     rootClass:[ErrorDetailsRoot class]
                                          file:ErrorDetailsRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(BadRequest__storage_)
                                         flags:0];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - BadRequest_FieldViolation

@implementation BadRequest_FieldViolation

@dynamic field;
@dynamic description_p;

typedef struct BadRequest_FieldViolation__storage_ {
  uint32_t _has_storage_[1];
  NSString *field;
  NSString *description_p;
} BadRequest_FieldViolation__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "field",
        .dataTypeSpecific.className = NULL,
        .number = BadRequest_FieldViolation_FieldNumber_Field,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(BadRequest_FieldViolation__storage_, field),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "description_p",
        .dataTypeSpecific.className = NULL,
        .number = BadRequest_FieldViolation_FieldNumber_Description_p,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(BadRequest_FieldViolation__storage_, description_p),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[BadRequest_FieldViolation class]
                                     rootClass:[ErrorDetailsRoot class]
                                          file:ErrorDetailsRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(BadRequest_FieldViolation__storage_)
                                         flags:0];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - RequestInfo

@implementation RequestInfo

@dynamic requestId;
@dynamic servingData;

typedef struct RequestInfo__storage_ {
  uint32_t _has_storage_[1];
  NSString *requestId;
  NSString *servingData;
} RequestInfo__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "requestId",
        .dataTypeSpecific.className = NULL,
        .number = RequestInfo_FieldNumber_RequestId,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(RequestInfo__storage_, requestId),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "servingData",
        .dataTypeSpecific.className = NULL,
        .number = RequestInfo_FieldNumber_ServingData,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(RequestInfo__storage_, servingData),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[RequestInfo class]
                                     rootClass:[ErrorDetailsRoot class]
                                          file:ErrorDetailsRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(RequestInfo__storage_)
                                         flags:0];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - ResourceInfo

@implementation ResourceInfo

@dynamic resourceType;
@dynamic resourceName;
@dynamic owner;
@dynamic description_p;

typedef struct ResourceInfo__storage_ {
  uint32_t _has_storage_[1];
  NSString *resourceType;
  NSString *resourceName;
  NSString *owner;
  NSString *description_p;
} ResourceInfo__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "resourceType",
        .dataTypeSpecific.className = NULL,
        .number = ResourceInfo_FieldNumber_ResourceType,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(ResourceInfo__storage_, resourceType),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "resourceName",
        .dataTypeSpecific.className = NULL,
        .number = ResourceInfo_FieldNumber_ResourceName,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(ResourceInfo__storage_, resourceName),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "owner",
        .dataTypeSpecific.className = NULL,
        .number = ResourceInfo_FieldNumber_Owner,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(ResourceInfo__storage_, owner),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "description_p",
        .dataTypeSpecific.className = NULL,
        .number = ResourceInfo_FieldNumber_Description_p,
        .hasIndex = 3,
        .offset = (uint32_t)offsetof(ResourceInfo__storage_, description_p),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[ResourceInfo class]
                                     rootClass:[ErrorDetailsRoot class]
                                          file:ErrorDetailsRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(ResourceInfo__storage_)
                                         flags:0];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - Help

@implementation Help

@dynamic linksArray, linksArray_Count;

typedef struct Help__storage_ {
  uint32_t _has_storage_[1];
  NSMutableArray *linksArray;
} Help__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "linksArray",
        .dataTypeSpecific.className = GPBStringifySymbol(Help_Link),
        .number = Help_FieldNumber_LinksArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(Help__storage_, linksArray),
        .flags = GPBFieldRepeated,
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[Help class]
                                     rootClass:[ErrorDetailsRoot class]
                                          file:ErrorDetailsRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(Help__storage_)
                                         flags:0];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - Help_Link

@implementation Help_Link

@dynamic description_p;
@dynamic URL;

typedef struct Help_Link__storage_ {
  uint32_t _has_storage_[1];
  NSString *description_p;
  NSString *URL;
} Help_Link__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "description_p",
        .dataTypeSpecific.className = NULL,
        .number = Help_Link_FieldNumber_Description_p,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(Help_Link__storage_, description_p),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "URL",
        .dataTypeSpecific.className = NULL,
        .number = Help_Link_FieldNumber_URL,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(Help_Link__storage_, URL),
        .flags = GPBFieldOptional | GPBFieldTextFormatNameCustom,
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[Help_Link class]
                                     rootClass:[ErrorDetailsRoot class]
                                          file:ErrorDetailsRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(Help_Link__storage_)
                                         flags:0];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\001\002!!!\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end


#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
