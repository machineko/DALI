// Copyright (c) 2017-2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


#include <vector>
#include <cmath>

#include "dali/pipeline/data/views.h"
#include "dali/operators/image/resize/random_resized_crop.h"
#include "dali/util/random_crop_generator.h"

namespace dali {

template<>
void RandomResizedCrop<GPUBackend>::BackendInit() {
  InitializeGPU(spec_.GetArgument<int>("minibatch_size"),
                spec_.GetArgument<int64_t>("temp_buffer_hint"));
}

template<>
void RandomResizedCrop<GPUBackend>::RunImpl(DeviceWorkspace &ws) {
  auto &input = ws.InputRef<GPUBackend>(0);
  auto &output = ws.OutputRef<GPUBackend>(0);
  RunResize(ws, output, input);
  output.SetLayout(input.GetLayout());
}

DALI_REGISTER_OPERATOR(RandomResizedCrop, RandomResizedCrop<GPUBackend>, GPU);

}  // namespace dali
