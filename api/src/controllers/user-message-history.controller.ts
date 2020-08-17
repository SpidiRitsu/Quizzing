import {
  Count,
  CountSchema,
  Filter,
  FilterExcludingWhere,
  repository,
  Where,
} from '@loopback/repository';
import {
  post,
  param,
  get,
  getModelSchemaRef,
  patch,
  put,
  del,
  requestBody,
} from '@loopback/rest';
import {UserMessageHistory} from '../models';
import {UserMessageHistoryRepository} from '../repositories';

export class UserMessageHistoryController {
  constructor(
    @repository(UserMessageHistoryRepository)
    public userMessageHistoryRepository: UserMessageHistoryRepository,
  ) {}

  @post('/user-message-history', {
    responses: {
      '200': {
        description: 'UserMessageHistory model instance',
        content: {
          'application/json': {schema: getModelSchemaRef(UserMessageHistory)},
        },
      },
    },
  })
  async create(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(UserMessageHistory, {
            title: 'NewUserMessageHistory',
            exclude: ['id'],
          }),
        },
      },
    })
    userMessageHistory: Omit<UserMessageHistory, 'id'>,
  ): Promise<UserMessageHistory> {
    return this.userMessageHistoryRepository.create(userMessageHistory);
  }

  @get('/user-message-history/count', {
    responses: {
      '200': {
        description: 'UserMessageHistory model count',
        content: {'application/json': {schema: CountSchema}},
      },
    },
  })
  async count(
    @param.where(UserMessageHistory) where?: Where<UserMessageHistory>,
  ): Promise<Count> {
    return this.userMessageHistoryRepository.count(where);
  }

  @get('/user-message-history', {
    responses: {
      '200': {
        description: 'Array of UserMessageHistory model instances',
        content: {
          'application/json': {
            schema: {
              type: 'array',
              items: getModelSchemaRef(UserMessageHistory, {
                includeRelations: true,
              }),
            },
          },
        },
      },
    },
  })
  async find(
    @param.filter(UserMessageHistory) filter?: Filter<UserMessageHistory>,
  ): Promise<UserMessageHistory[]> {
    return this.userMessageHistoryRepository.find(filter);
  }

  @patch('/user-message-history', {
    responses: {
      '200': {
        description: 'UserMessageHistory PATCH success count',
        content: {'application/json': {schema: CountSchema}},
      },
    },
  })
  async updateAll(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(UserMessageHistory, {partial: true}),
        },
      },
    })
    userMessageHistory: UserMessageHistory,
    @param.where(UserMessageHistory) where?: Where<UserMessageHistory>,
  ): Promise<Count> {
    return this.userMessageHistoryRepository.updateAll(
      userMessageHistory,
      where,
    );
  }

  @get('/user-message-history/{id}', {
    responses: {
      '200': {
        description: 'UserMessageHistory model instance',
        content: {
          'application/json': {
            schema: getModelSchemaRef(UserMessageHistory, {
              includeRelations: true,
            }),
          },
        },
      },
    },
  })
  async findById(
    @param.path.number('id') id: number,
    @param.filter(UserMessageHistory, {exclude: 'where'})
    filter?: FilterExcludingWhere<UserMessageHistory>,
  ): Promise<UserMessageHistory> {
    return this.userMessageHistoryRepository.findById(id, filter);
  }

  @patch('/user-message-history/{id}', {
    responses: {
      '204': {
        description: 'UserMessageHistory PATCH success',
      },
    },
  })
  async updateById(
    @param.path.number('id') id: number,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(UserMessageHistory, {partial: true}),
        },
      },
    })
    userMessageHistory: UserMessageHistory,
  ): Promise<void> {
    await this.userMessageHistoryRepository.updateById(id, userMessageHistory);
  }

  @put('/user-message-history/{id}', {
    responses: {
      '204': {
        description: 'UserMessageHistory PUT success',
      },
    },
  })
  async replaceById(
    @param.path.number('id') id: number,
    @requestBody() userMessageHistory: UserMessageHistory,
  ): Promise<void> {
    await this.userMessageHistoryRepository.replaceById(id, userMessageHistory);
  }

  @del('/user-message-history/{id}', {
    responses: {
      '204': {
        description: 'UserMessageHistory DELETE success',
      },
    },
  })
  async deleteById(@param.path.number('id') id: number): Promise<void> {
    await this.userMessageHistoryRepository.deleteById(id);
  }
}
