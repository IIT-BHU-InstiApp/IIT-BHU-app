import 'package:chopper/chopper.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:built_collection/built_collection.dart';

import 'built_value_converter.dart';
import 'mobile_data_interceptor.dart';

part 'post_api_service.chopper.dart';

@ChopperApi(baseUrl: '')
abstract class PostApiService extends ChopperService {
  @Get(path: '/workshops')
  Future<Response<BuiltList<BuiltPost>>> getUpcomingWorkshops();

  @Get(path: '/workshops/{id}')
  Future<Response<BuiltPost>> getPost(@Path('id') int id);

  @Post()
  Future<Response<BuiltPost>> postPost(
    @Body() BuiltPost body,
  );

  static PostApiService create() {
    final client = ChopperClient(
      baseUrl: 'https://workshops-app-backend.herokuapp.com',
      services: [
        _$PostApiService(),
      ],
      converter: BuiltValueConverter(),
      interceptors: [HttpLoggingInterceptor()],
    );
    return _$PostApiService(client);
  }
}
