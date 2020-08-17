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
import {AnswerHistory} from '../models';
import {AnswerHistoryRepository} from '../repositories';

export class AnswerHistoryController {
  constructor(
    @repository(AnswerHistoryRepository)
    public answerHistoryRepository: AnswerHistoryRepository,
  ) {}

  @post('/answer-history', {
    responses: {
      '200': {
        description: 'AnswerHistory model instance',
        content: {
          'application/json': {schema: getModelSchemaRef(AnswerHistory)},
        },
      },
    },
  })
  async create(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(AnswerHistory, {
            title: 'NewAnswerHistory',
            exclude: ['id'],
          }),
        },
      },
    })
    answerHistory: Omit<AnswerHistory, 'id'>,
  ): Promise<AnswerHistory> {
    return this.answerHistoryRepository.create(answerHistory);
  }

  @get('/answer-history/count', {
    responses: {
      '200': {
        description: 'AnswerHistory model count',
        content: {'application/json': {schema: CountSchema}},
      },
    },
  })
  async count(
    @param.where(AnswerHistory) where?: Where<AnswerHistory>,
  ): Promise<Count> {
    return this.answerHistoryRepository.count(where);
  }

  @get('/answer-history', {
    responses: {
      '200': {
        description: 'Array of AnswerHistory model instances',
        content: {
          'application/json': {
            schema: {
              type: 'array',
              items: getModelSchemaRef(AnswerHistory, {includeRelations: true}),
            },
          },
        },
      },
    },
  })
  async find(
    @param.filter(AnswerHistory) filter?: Filter<AnswerHistory>,
  ): Promise<AnswerHistory[]> {
    return this.answerHistoryRepository.find(filter);
  }

  @patch('/answer-history', {
    responses: {
      '200': {
        description: 'AnswerHistory PATCH success count',
        content: {'application/json': {schema: CountSchema}},
      },
    },
  })
  async updateAll(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(AnswerHistory, {partial: true}),
        },
      },
    })
    answerHistory: AnswerHistory,
    @param.where(AnswerHistory) where?: Where<AnswerHistory>,
  ): Promise<Count> {
    return this.answerHistoryRepository.updateAll(answerHistory, where);
  }

  @get('/answer-history/{id}', {
    responses: {
      '200': {
        description: 'AnswerHistory model instance',
        content: {
          'application/json': {
            schema: getModelSchemaRef(AnswerHistory, {includeRelations: true}),
          },
        },
      },
    },
  })
  async findById(
    @param.path.number('id') id: number,
    @param.filter(AnswerHistory, {exclude: 'where'})
    filter?: FilterExcludingWhere<AnswerHistory>,
  ): Promise<AnswerHistory> {
    return this.answerHistoryRepository.findById(id, filter);
  }

  @patch('/answer-history/{id}', {
    responses: {
      '204': {
        description: 'AnswerHistory PATCH success',
      },
    },
  })
  async updateById(
    @param.path.number('id') id: number,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(AnswerHistory, {partial: true}),
        },
      },
    })
    answerHistory: AnswerHistory,
  ): Promise<void> {
    await this.answerHistoryRepository.updateById(id, answerHistory);
  }

  @put('/answer-history/{id}', {
    responses: {
      '204': {
        description: 'AnswerHistory PUT success',
      },
    },
  })
  async replaceById(
    @param.path.number('id') id: number,
    @requestBody() answerHistory: AnswerHistory,
  ): Promise<void> {
    await this.answerHistoryRepository.replaceById(id, answerHistory);
  }

  @del('/answer-history/{id}', {
    responses: {
      '204': {
        description: 'AnswerHistory DELETE success',
      },
    },
  })
  async deleteById(@param.path.number('id') id: number): Promise<void> {
    await this.answerHistoryRepository.deleteById(id);
  }
}
