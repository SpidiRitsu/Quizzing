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
import {QuizAttached} from '../models';
import {QuizAttachedRepository} from '../repositories';

export class QuizAttachedController {
  constructor(
    @repository(QuizAttachedRepository)
    public quizAttachedRepository: QuizAttachedRepository,
  ) {}

  @post('/quiz-attached', {
    responses: {
      '200': {
        description: 'QuizAttached model instance',
        content: {
          'application/json': {schema: getModelSchemaRef(QuizAttached)},
        },
      },
    },
  })
  async create(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(QuizAttached, {
            title: 'NewQuizAttached',
            exclude: ['id'],
          }),
        },
      },
    })
    quizAttached: Omit<QuizAttached, 'id'>,
  ): Promise<QuizAttached> {
    return this.quizAttachedRepository.create(quizAttached);
  }

  @get('/quiz-attached/count', {
    responses: {
      '200': {
        description: 'QuizAttached model count',
        content: {'application/json': {schema: CountSchema}},
      },
    },
  })
  async count(
    @param.where(QuizAttached) where?: Where<QuizAttached>,
  ): Promise<Count> {
    return this.quizAttachedRepository.count(where);
  }

  @get('/quiz-attached', {
    responses: {
      '200': {
        description: 'Array of QuizAttached model instances',
        content: {
          'application/json': {
            schema: {
              type: 'array',
              items: getModelSchemaRef(QuizAttached, {includeRelations: true}),
            },
          },
        },
      },
    },
  })
  async find(
    @param.filter(QuizAttached) filter?: Filter<QuizAttached>,
  ): Promise<QuizAttached[]> {
    return this.quizAttachedRepository.find(filter);
  }

  @patch('/quiz-attached', {
    responses: {
      '200': {
        description: 'QuizAttached PATCH success count',
        content: {'application/json': {schema: CountSchema}},
      },
    },
  })
  async updateAll(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(QuizAttached, {partial: true}),
        },
      },
    })
    quizAttached: QuizAttached,
    @param.where(QuizAttached) where?: Where<QuizAttached>,
  ): Promise<Count> {
    return this.quizAttachedRepository.updateAll(quizAttached, where);
  }

  @get('/quiz-attached/{id}', {
    responses: {
      '200': {
        description: 'QuizAttached model instance',
        content: {
          'application/json': {
            schema: getModelSchemaRef(QuizAttached, {includeRelations: true}),
          },
        },
      },
    },
  })
  async findById(
    @param.path.number('id') id: number,
    @param.filter(QuizAttached, {exclude: 'where'})
    filter?: FilterExcludingWhere<QuizAttached>,
  ): Promise<QuizAttached> {
    return this.quizAttachedRepository.findById(id, filter);
  }

  @patch('/quiz-attached/{id}', {
    responses: {
      '204': {
        description: 'QuizAttached PATCH success',
      },
    },
  })
  async updateById(
    @param.path.number('id') id: number,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(QuizAttached, {partial: true}),
        },
      },
    })
    quizAttached: QuizAttached,
  ): Promise<void> {
    await this.quizAttachedRepository.updateById(id, quizAttached);
  }

  @put('/quiz-attached/{id}', {
    responses: {
      '204': {
        description: 'QuizAttached PUT success',
      },
    },
  })
  async replaceById(
    @param.path.number('id') id: number,
    @requestBody() quizAttached: QuizAttached,
  ): Promise<void> {
    await this.quizAttachedRepository.replaceById(id, quizAttached);
  }

  @del('/quiz-attached/{id}', {
    responses: {
      '204': {
        description: 'QuizAttached DELETE success',
      },
    },
  })
  async deleteById(@param.path.number('id') id: number): Promise<void> {
    await this.quizAttachedRepository.deleteById(id);
  }
}
